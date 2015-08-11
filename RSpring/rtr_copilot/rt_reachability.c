#define PARAMS 2
#define PHI 0.00001
#define PENDULUM "PENDULUM"
#define VANDERPOL "VANDERPOL"
#define NONLINEAR_PENDULUM "NONLINEAR_PENDULUM"

#include "rt_face_lift.h"
#include "util.h"

#include "pendulum_params.h"
#include "nonlinear_pendulum_params.h"
#include "vanderpol_params.h"

#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>

#ifndef M_PI
#define M_PI 3.14159
#endif

// Objective: Keep angle of inverted pendulum upright 
int main(int argc, char** argv)
{
	if(argc != PARAMS)
	{
		printf("Missing RTR Monitor Type Parameter\n");
	}
	else if(!strcmp(argv[1], PENDULUM))
	{
		extern struct Monitor pendulum_params;
		const double PENDULUM_REACH_TIME = 0.75;
		face_lift(&pendulum_params, PENDULUM_REACH_TIME, true);
	}
	else if(!strcmp(argv[1], NONLINEAR_PENDULUM))
	{
		/* RTR Monitor Global Variables */
		struct Interval nonlinear_pendulum_dims[NONLINEAR_PENDULUM_NUM_STATES] = { 0 };
		struct HyperRect nonlinear_pendulum_rset = { nonlinear_pendulum_dims };

		struct Interval nonlinear_pendulum_neighborhood_dims[NONLINEAR_PENDULUM_NUM_STATES] = { 0 };
		struct HyperRect nonlinear_pendulum_neighborhood_rset = { nonlinear_pendulum_neighborhood_dims };

		const struct Interval nonlinear_pendulum_constraints[NONLINEAR_PENDULUM_NUM_STATES] =
		{
			{-DBL_MAX, DBL_MAX},
			{-M_PI / 3.0, M_PI / 3.0},
			{-5.0, 5.0},
			{-DBL_MAX, DBL_MAX}
		};

		struct Monitor nonlinear_pendulum_params =
		{
			NONLINEAR_PENDULUM_NUM_STATES,
			STEPS300,
			nonlinear_pendulum_constraints,
			&nonlinear_pendulum_derivative,
			&nonlinear_pendulum_updateInflectionPoints,
			&nonlinear_pendulum_rset,
			&nonlinear_pendulum_neighborhood_rset
		};

		const double NONLINEAR_PENDULUM_REACH_TIME = 0.75;

		nonlinear_pendulum_params.rset->dims[0].min = 0;
		nonlinear_pendulum_params.rset->dims[0].max = 0;

		nonlinear_pendulum_params.rset->dims[1].min = 1.00;
		nonlinear_pendulum_params.rset->dims[1].max = 1.00 + PHI;

		nonlinear_pendulum_params.rset->dims[2].min = 0;
		nonlinear_pendulum_params.rset->dims[2].max = 0;

		nonlinear_pendulum_params.rset->dims[3].min = 0;
		nonlinear_pendulum_params.rset->dims[3].max = 0;

		// Print Current State and RTR Monitor State
		face_lift(&nonlinear_pendulum_params, NONLINEAR_PENDULUM_REACH_TIME, true);
	}
	else if(!strcmp(argv[1], VANDERPOL))
	{
		extern struct Monitor vanderpol_params;
		const double DELTA = 0.01;
		const double VANDERPOL_REACH_TIME = 2.0;
		const double MAX_VANDERPOL_REACH_TIME = 12.0;

		for(double n = 0; n < MAX_VANDERPOL_REACH_TIME; n += VANDERPOL_REACH_TIME)
		{
			face_lift(&vanderpol_params, VANDERPOL_REACH_TIME, true);
			compressRset(&vanderpol_params, DELTA);
		}
	}
	return 0;
}
