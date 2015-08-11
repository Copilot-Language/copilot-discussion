#ifndef _NONLINEAR_PENDULUM_PARAMS_H_
#define _NONLINEAR_PENDULUM_PARAMS_H_

#define NONLINEAR_PENDULUM_NUM_STATES 4

#include "constants.h"
#include "hyper_rect.h"
#include "util.h"

#include <math.h>

static double control_action(double* state);
static double pos_derivative(double* state);
static double theta_derivative(double* state);
static double vel_derivative(double* state);
static double omega_derivative(double* state);
void nonlinear_pendulum_updateInflectionPoints(struct Interval* rv, int dim, struct HyperRect* box);
double nonlinear_pendulum_derivative(int dim, double* state);
#endif // _NONLINEAR_PENDULUM_PARAMS_H_
