#ifndef _PENDULUM_PARAMS_H_
#define _PENDULUM_PARAMS_H_

#define PENDULUM_NUM_STATES 4
#define PENDULUM_NUM_INPUTS 1

#include "constants.h"
#include "hyper_rect.h"
#include "util.h"

#include <float.h>

extern const double pendulum_A[PENDULUM_NUM_STATES][PENDULUM_NUM_STATES];
extern const double pendulum_B[PENDULUM_NUM_STATES][PENDULUM_NUM_INPUTS];

extern const double pendulum_K[PENDULUM_NUM_INPUTS][PENDULUM_NUM_STATES];
extern const struct Interval pendulum_input_constraints[PENDULUM_NUM_INPUTS];

void pendulum_updateInflectionPoints(struct Interval* rv, int dim, struct HyperRect* box);
double pendulum_derivative(int dim, double* state);
#endif // _PENDULUM_PARAMS_H_
