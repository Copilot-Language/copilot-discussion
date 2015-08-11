#include <ompl/control/SpaceInformation.h>
#include <ompl/base/spaces/SE2StateSpace.h>
#include <ompl/control/spaces/RealVectorControlSpace.h>
#include <ompl/control/ODESolver.h>
#include <ompl/control/SimpleSetup.h>
#include <ompl/tools/benchmark/Benchmark.h>
#include <omplapp/config.h>
#include <ompl/config.h>
#include <iostream>
#include <valarray>
#include <limits>
#include <fstream>
#include <vector>
#include <math.h>
#include <float.h>

#include "pid_ctrl.h"

const double GAMMA = 0.01;
const double G = 9.81;
const double l = 0.3;
const double m = 0.25;
const double M = 0.5;

// Pendulum Limits
const double xaxis_limit = 4.5;

extern "C" 
{
#include "constants.h"
#include "nonlinear_pendulum_params.h"
#include "rt_face_lift.h"
}

/* RTR Monitor Global Variables */
struct Interval nonlinear_pendulum_dims[NONLINEAR_PENDULUM_NUM_STATES] = { 0 };
struct HyperRect nonlinear_pendulum_rset = { nonlinear_pendulum_dims };

struct Interval nonlinear_pendulum_neighborhood_dims[NONLINEAR_PENDULUM_NUM_STATES] = { 0 };
struct HyperRect nonlinear_pendulum_neighborhood_rset = { nonlinear_pendulum_neighborhood_dims };

const struct Interval nonlinear_pendulum_constraints[NONLINEAR_PENDULUM_NUM_STATES] =
{
	{-DBL_MAX, DBL_MAX},
	{-M_PI / 3.0, M_PI / 3.0},
	{-5.0, 5.0},
	{-DBL_MAX, DBL_MAX}
};

struct Monitor nonlinear_pendulum_params =
{
	NONLINEAR_PENDULUM_NUM_STATES,
	STEPS300,
	nonlinear_pendulum_constraints,
	&nonlinear_pendulum_derivative,
	&nonlinear_pendulum_updateInflectionPoints,
	&nonlinear_pendulum_rset,
	&nonlinear_pendulum_neighborhood_rset
};

const double NONLINEAR_PENDULUM_REACH_TIME = 0.25;
/***********************************************************************************************/

typedef std::pair<double, double> Point2D;
typedef std::vector<Point2D> Rect;

namespace ob = ompl::base;
namespace oc = ompl::control;

// Definition of the ODE for the pendulum
void PendulumODE (const oc::ODESolver::StateType& q, const oc::Control* control, oc::ODESolver::StateType& qdot)
{
	const double* u = control->as<oc::RealVectorControlSpace::ControlType>()->values;
	const double pos = q[0];
	const double theta = q[1];
	const double vel = q[2];
	const double omega = q[3];

	// Zero out qdot
	qdot.resize (q.size(), 0);

	qdot[0] = vel;
	qdot[1] = omega;

	double dt2_num = *u + m * l * sin(theta) * pow(omega, 2.0) - m * G * cos(theta) * sin(theta);
	double dt2_den = M + m - m * pow(cos(theta), 2.0);
	qdot[2] = dt2_num / dt2_den;

	double dt3_num = *u * cos(theta) - (M+m) * G * sin(theta) + m * l * (cos(theta) * sin(theta)) * omega;
	double dt3_den = m * l * pow(cos(theta), 2.0) - (M+m) * l;
	qdot[3] = dt3_num / dt3_den;
}

// This is a callback method invoked after numerical integration.
void PendulumPostIntegration (const ob::State* /*state*/, const oc::Control* /*control*/, const double /*duration*/, ob::State *result)
{
	const ompl::base::CompoundState* cstate = result->as<ompl::base::CompoundState>();

	const ob::RealVectorStateSpace::StateType *pos = cstate->as<ob::RealVectorStateSpace::StateType>(0);
	const ob::SO2StateSpace::StateType *theta = cstate->as<ob::SO2StateSpace::StateType>(1);
	const ob::RealVectorStateSpace::StateType *vel = cstate->as<ob::RealVectorStateSpace::StateType>(2);
	const ob::SO2StateSpace::StateType *omega = cstate->as<ob::SO2StateSpace::StateType>(3);

	if(pos->values[0] < -xaxis_limit)
	{
		pos->values[0]  = -xaxis_limit;
		vel->values[0] = 0.0;
	}
	else if(pos->values[0] > xaxis_limit)
	{
		pos->values[0] = xaxis_limit;
		vel->values[0] = 0.0;
	}

	// Initialize rset for current state
	nonlinear_pendulum_params.rset->dims[0].min = pos->values[0];
	nonlinear_pendulum_params.rset->dims[0].max = pos->values[0];

	nonlinear_pendulum_params.rset->dims[1].min = theta->value;
	nonlinear_pendulum_params.rset->dims[1].max = theta->value + GAMMA;

	nonlinear_pendulum_params.rset->dims[2].min = vel->values[0];
	nonlinear_pendulum_params.rset->dims[2].max = vel->values[0];

	nonlinear_pendulum_params.rset->dims[3].min = omega->value;
	nonlinear_pendulum_params.rset->dims[3].max = omega->value;

	// Print Current State and RTR Monitor State
	std::cout << pos->values[0] << " " << theta->value << " " << vel->values[0] << " " << omega->value << std::endl;
	if(!face_lift(&nonlinear_pendulum_params, NONLINEAR_PENDULUM_REACH_TIME, false))
	{
		std::cout << "Dynamic_System_Failure" << std::endl;
	}
	else
	{
		std::cout << "Safe" << std::endl;
	}
}

bool isStateValidPen(const ob::State *state)
{
	return true;
}

void planWithSimpleSetupPen(std::string title = "Default")
{
	// x, theta, velocity, angular veloctiy
	ompl::base::StateSpacePtr space;
	ompl::base::StateSpacePtr pos(new ompl::base::RealVectorStateSpace(1));
	ompl::base::StateSpacePtr theta(new ompl::base::SO2StateSpace());
	ompl::base::StateSpacePtr vel(new ompl::base::RealVectorStateSpace(1));
	ompl::base::StateSpacePtr omega(new ompl::base::SO2StateSpace());

	ompl::base::RealVectorBounds position_limit(1);
	position_limit.setLow(-xaxis_limit);
	position_limit.setHigh(xaxis_limit);
	pos->as<ompl::base::RealVectorStateSpace>()->setBounds(position_limit);

	ompl::base::RealVectorBounds vel_limit(1);
	vel_limit.setLow(-std::numeric_limits<double>::infinity());
	vel_limit.setHigh(std::numeric_limits<double>::infinity());
	vel->as<ompl::base::RealVectorStateSpace>()->setBounds(vel_limit);

	space = pos + theta + vel + omega;

	// create a control space
	oc::ControlSpacePtr cspace(new oc::RealVectorControlSpace(space, 1));

	// set the bounds for the control space
	//ob::RealVectorBounds cbounds(1);
	//cbounds.setLow(0);
	//cbounds.setHigh(acceleration_limit);
	//cspace->as<RealVectorControlSpace>()->setBounds(cbounds);

	// define a simple setup class
	oc::SimpleSetup ss(cspace);

	// set state validity checking for this space
	ss.setStateValidityChecker(isStateValidPen);

	// Use the ODESolver to propagate the system.  Call KinematicCarPostIntegration
	// when integration has finished to normalize the orientation values.
	oc::ODESolverPtr odeSolver(new oc::ODEBasicSolver<> (ss.getSpaceInformation(), &PendulumODE));
	ss.setStatePropagator(oc::ODESolver::getStatePropagator(odeSolver, PendulumPostIntegration));

	/// create a start state
	ob::ScopedState<> start(space);
	start[0] = 0.0;
	start[1] = -0.35;
	start[2] = 0.0;
	start[3] = 0.0;

	/// create a goal state; use the hard way to set the elements
	ob::ScopedState<> goal(space);
	goal[1] = 0.0;
	goal[3] = 0.0;

	/// set the start and goal states
	ss.setStartAndGoalStates(start, goal, 0.05);
	ss.getSpaceInformation()->setMinMaxControlDuration(1, 10);

	ss.getSpaceInformation()->setPropagationStepSize(0.01);
	ompl::base::PlannerPtr planner(new ompl::control::PID(ss.getSpaceInformation()));
	ss.setPlanner(planner);

	ss.setup();

	/// attempt to solve the problem within one second of planning time
	ob::PlannerStatus solved = ss.solve(10);

	/*
	   if (solved)
	   {
	   ompl::control::PathControl& path = ss.getSolutionPath();
	   path.printAsMatrix(std::cout);

	// print path to file
	std::ofstream fout("path.txt");
	path.printAsMatrix(fout);
	fout.close();
	}
	*/
}

int main(int, char **)
{
	planWithSimpleSetupPen("Benchmark-Pendulum");
	return 0;
}
