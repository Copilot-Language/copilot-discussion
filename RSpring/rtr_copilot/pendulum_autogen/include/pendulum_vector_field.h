#ifndef _PENDULUM_VECTOR_FIELD_H
#define _PENDULUM_VECTOR_FIELD_H

#include "pendulum_params.h"
#include "rt_face_lift.h"

const struct Interval PENDULUM_STATE_BOUNDS[PENDULUM_NUM_STATES] =
{
	{0, 1.25},
	{0, 1.2},
	{-20, 20},
	{-30, 30}
};

const double PENDULUM_STEP = 0.05;
const double PENDULUM_SAMPLES = 15.0;

double pendulum_hyperPoint[PENDULUM_NUM_STATES] = { 0 };
#endif // _PENDULUM_VECTOR_FIELD_H
