#include "linear_control.h"
#include "linear.h"

double bound(struct Interval i, double value)
{
	if(value > i.max)
	{
		return i.max;
	}
	else if(value < i.min)
	{
		return i.min;
	}
	else
	{
		return value;
	}
}

void check_input(struct LinearParams * const params, double* values)
{
	for(unsigned i = 0; i < params->NUM_INPUTS; ++i)
	{
		values[i] = bound(params->input_constraints[i], values[i]);
	}
}

void generate_input(struct LinearParams * const params, double* state)
{
	for(unsigned i = 0; i < params->NUM_INPUTS; ++i)
	{
		for(unsigned j = 0; j < params->NUM_STATES; ++j)
		{
			params->u[i] += params->K[i * params->NUM_INPUTS + j] * state[j];
		}
	}
	check_input(params, params->u);
}
