#include "pendulum_params.h"
#include "linear.h"

/* RTR Monitor Parameters */
struct Interval pendulum_dims[PENDULUM_NUM_STATES] =
{
	{-0.001, 0.001},
	{0.85, 0.85},
	{0, 0},
	{0, 0}
};

struct HyperRect pendulum_rset =
{
	pendulum_dims
};

struct Interval pendulum_neighborhood_dims[PENDULUM_NUM_STATES] = { 0 };
struct HyperRect pendulum_neighborhood_rset = { pendulum_neighborhood_dims };

// state contraints
const struct Interval pendulum_constraints[PENDULUM_NUM_STATES] =
{
	{-1.0, 1.0},
	{-1.0, 1.0},
	{-30.0, 30.0},
	{-DBL_MAX, DBL_MAX}
};

struct Monitor pendulum_params =
{
	PENDULUM_NUM_STATES,
	STEPS1250,
	pendulum_constraints,
	&pendulum_derivative,
	&pendulum_updateInflectionPoints,
	&pendulum_rset,
	&pendulum_neighborhood_rset
};

/* Linear Model Parameters */
// x' = Ax + Bu
const double pendulum_A[PENDULUM_NUM_STATES][PENDULUM_NUM_STATES] =
{
	{0,1,0,0},
	{0,-10.95,-2.75,0.0043},
	{0,0,0,1},
	{0,24.92,28.58,-0.044}
};

const double pendulum_B[PENDULUM_NUM_STATES][PENDULUM_NUM_INPUTS] =
{
	{0},
	{1.94},
	{0},
	{-4.44}
};

const double pendulum_K[PENDULUM_NUM_INPUTS][PENDULUM_NUM_STATES] =
{
	{0.4072, 7.2373, 18.6269, 3.6725}
	//{7.6, 13.54, 42.85, 8.25}
	//{3.16, 19.85, 69.92, 14.38}
	//{10.0, 27.72, 103.36, 23.04}
	//{0,0,0,0}
};

// input constraints
const struct Interval pendulum_input_constraints[PENDULUM_NUM_INPUTS] =
{
	{-4.95, 4.95}
};

double pendulum_derivative(int dim, double* state)
{
	double u[PENDULUM_NUM_INPUTS] = {0};
	struct LinearParams params =
	{
		PENDULUM_NUM_STATES,
		PENDULUM_NUM_INPUTS,
		(const double *) pendulum_A,
		(const double *) pendulum_B,
		(const double *) pendulum_K,
		pendulum_input_constraints,
		u
	};
	return linear_derivative(&params, dim, state);
}

void pendulum_updateInflectionPoints(struct Interval* rv, int dim, struct HyperRect* box)
{
	return;
}
