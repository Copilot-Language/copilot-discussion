#include "vanderpol_params.h"

struct Interval vanderpol_dims[VANDERPOL_NUM_STATES] =
{
	{1.0, 1.0},
	{0.20, 0.21}
};

struct HyperRect vanderpol_rset = { vanderpol_dims };

struct Interval vanderpol_neighborhood_dims[VANDERPOL_NUM_STATES] = { 0 };
struct HyperRect vanderpol_neighborhood_rset = { vanderpol_neighborhood_dims };

const struct Interval vanderpol_constraints[VANDERPOL_NUM_STATES] =
{
	{-10.0, 10.0},
	{-10.0, 10.0}
};

struct Monitor vanderpol_params =
{
	VANDERPOL_NUM_STATES,
	STEPS300,
	vanderpol_constraints,
	&vanderpol_derivative,
	&vanderpol_updateInflectionPoints,
	&vanderpol_rset,
	&vanderpol_neighborhood_rset
};

double x_derivative(double* state)
{
	return state[1];
}

double y_derivative(double* state)
{
	return (1 - pow(state[0], 2)) * state[1] - state[0];
}

double vanderpol_derivative(int dim, double* state)
{
	switch(dim)
	{
		case 0:
			{
				return x_derivative(state);
			}
		case 1:
			{
				return y_derivative(state);
			}
		default:
			{
				return 0.0;
			}
	}
}

void vanderpol_updateInflectionPoints(struct Interval* rv, int dim, struct HyperRect* box)
{
	if(contains(&box->dims[0], 1.0) && contains(&box->dims[1], -0.5))
	{
		double HyperPoint[VANDERPOL_NUM_STATES] = {1,-0.5};
		double dv = vanderpol_derivative(dim, HyperPoint);
		updateInterval(rv, dv);
	}

	if(contains(&box->dims[0], -1.0) && contains(&box->dims[1], 0.5))
	{
		double HyperPoint[VANDERPOL_NUM_STATES] = {-1,0.5};
		double dv = vanderpol_derivative(dim, HyperPoint);
		updateInterval(rv, dv);
	}

	double xmin = -1/(2 * box->dims[1].min);
	if(contains(&box->dims[0], xmin))
	{
		double HyperPoint[VANDERPOL_NUM_STATES] = {xmin, box->dims[1].min};
		double dv = vanderpol_derivative(dim, HyperPoint);
		updateInterval(rv, dv);
	}

	double xmax = -1/(2 * box->dims[1].max);
	if(contains(&box->dims[0], xmax))
	{
		double HyperPoint[VANDERPOL_NUM_STATES] = {xmax, box->dims[1].max};
		double dv = vanderpol_derivative(dim, HyperPoint);
		updateInterval(rv, dv);
	}
}
