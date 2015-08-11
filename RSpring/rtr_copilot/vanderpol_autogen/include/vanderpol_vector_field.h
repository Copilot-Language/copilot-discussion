#ifndef VANDERPOL_VECTOR_FIELD_H
#define VANDERPOL_VECTOR_FIELD_H

#include "vanderpol_params.h"
#include "rt_face_lift.h"

const struct Interval VANDERPOL_STATE_BOUNDS[VANDERPOL_NUM_STATES] =
{
	{-2.5, 2.5},
	{-2.5, 2.5},
};

const double VANDERPOL_STEP = 0.05;
const double VANDERPOL_SAMPLES = 30.0;

double vanderpol_hyperPoint[VANDERPOL_NUM_STATES] = {0};
#endif // VANDERPOL_VECTOR_FIELD_H
