#ifndef LINEAR_H
#define LINEAR_H

#include "interval.h"

struct LinearParams
{
	const unsigned NUM_STATES;
	const unsigned NUM_INPUTS;
	const double * const A;
	const double * const B;
	const double * const K;
	const struct Interval * input_constraints;
	double * const u;
};

double linear_derivative(struct LinearParams * const params, int dim, double* state);

#endif // LINEAR_H
