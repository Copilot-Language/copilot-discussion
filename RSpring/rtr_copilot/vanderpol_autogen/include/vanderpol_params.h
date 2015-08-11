#ifndef _VANDERPOL_PARAMS_H_
#define _VANDERPOL_PARAMS_H_

#define VANDERPOL_NUM_STATES 2

#include "constants.h"
#include "hyper_rect.h"
#include "util.h"

#include <math.h>

static double x_derivative(double* state);
static double y_derivative(double* state);
void vanderpol_updateInflectionPoints(struct Interval* rv, int dim, struct HyperRect* box);
double vanderpol_derivative(int dim, double* state);
#endif // _VANDERPOL_PARAMS_H_
