#include <ompl/base/spaces/SE2StateSpace.h>
#include <ompl/control/spaces/RealVectorControlSpace.h>
#include <ompl/tools/config/SelfConfig.h>
#include <limits>
#include <boost/function.hpp>
#include <boost/bind.hpp>

#include "pid_ctrl.h"

namespace ob = ompl::base;
namespace oc = ompl::control;

ompl::control::PID::PID(const SpaceInformationPtr &si) : base::Planner(si, "PID")
{
	specs_.approximateSolutions = true;
	siC_ = si.get();
}

ompl::control::PID::~PID(void)
{
}

void ompl::control::PID::setup(void)
{
	base::Planner::setup();
}

void ompl::control::PID::clear(void)
{
	Planner::clear();
	sampler_.reset();
	controlSampler_.reset();
}

void ompl::control::PID::control_action(oc::Control*& control, ob::State*& state)
{
	static const double KP = 25.0;
	static const double KD = 5.0;
	//static const double KP = 0.0;
	//static const double KD = 0.0;
	double* u = control->as<oc::RealVectorControlSpace::ControlType>()->values;

	const ompl::base::CompoundState* cstate = state->as<ompl::base::CompoundState>();
	const ompl::base::SO2StateSpace::StateType* theta = cstate->as<ompl::base::SO2StateSpace::StateType>(1);
	const ompl::base::SO2StateSpace::StateType* omega = cstate->as<ompl::base::SO2StateSpace::StateType>(3);

	*u = KP * theta->value + KD * omega->value;
}
ompl::base::PlannerStatus ompl::control::PID::solve(const base::PlannerTerminationCondition &ptc)
{
	checkValidity();
	base::Goal                   *goal = pdef_->getGoal().get();

	while (const base::State *st = pis_.nextStart())
	{
		motions.push_back(new Motion(siC_));
		si_->copyState(motions.back()->state, st);
		siC_->nullControl(motions.back()->control);
	}

	if(motions.empty())
	{
		OMPL_ERROR("Invalid Start State");
		return base::PlannerStatus::INVALID_START;
	}

	if (!sampler_)
	{
		sampler_ = si_->allocStateSampler();
	}

	if (!controlSampler_)
	{
		controlSampler_ = siC_->allocDirectedControlSampler();
	}

	bool solved = false;
	double  approxdif = std::numeric_limits<double>::infinity();
	while (ptc == false)
	{
		/* create a motion */
		// Add PID control action
		Motion* new_motion = new Motion(siC_);
		new_motion->state = si_->allocState();
		siC_->nullControl(new_motion->control);
		control_action(new_motion->control, motions.back()->state);

		// Add State Propagation
		unsigned int cd = siC_->propagateWhileValid(motions.back()->state, new_motion->control, siC_->getMinControlDuration(), new_motion->state); 
		motions.push_back(new_motion);

		double dist = 0.0;
		bool solv = goal->isSatisfied(new_motion->state, &dist);
		if(solv)
		{
			solved = true;
		}

		if(dist < approxdif)
		{
			approxdif = dist;
		}
	}

	/* set the solution path */
	PathControl *path = new PathControl(si_);
	for (unsigned i = 0 ; i < motions.size()-1; ++i)
	{
		path->append(motions[i]->state, motions[i]->control, siC_->getPropagationStepSize());
	}
	path->append(motions[motions.size()-1]->state);
	pdef_->addSolutionPath(base::PathPtr(path), false, approxdif);
	return base::PlannerStatus(true, solved);
}

void ompl::control::PID::getPlannerData(base::PlannerData &data) const
{
	Planner::getPlannerData(data);
	double delta = siC_->getPropagationStepSize();

	if (motions.back())
	{
		data.addGoalVertex(base::PlannerDataVertex(motions.back()->state));
	}

	for (int i = motions.size()-1 ; i >= 1 ; --i)
	{
		const Motion* m = motions[i];
		data.addEdge(base::PlannerDataVertex(motions[i-1]->state), base::PlannerDataVertex(m->state), control::PlannerDataEdgeControl(m->control, delta));
	}
	data.addStartVertex(base::PlannerDataVertex(motions.front()->state));
}
