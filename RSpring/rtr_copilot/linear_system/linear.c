#include "linear.h"
#include "linear_control.h"

double linear_derivative(struct LinearParams * const params, int dim, double* state)
{
	// return value
	double rv = 0;

	// AX
	for(int i = 0; i < params->NUM_STATES; ++i)
	{
		rv += params->A[dim * params->NUM_STATES + i] * state[i];
	}

	// input saturation
	// u = KX
	generate_input(params, state);

	// Bu
	for(int i = 0; i < params->NUM_INPUTS; ++i)
	{
		rv += params->B[dim * params->NUM_INPUTS + i] * params->u[i];
	}
	return rv;
}
