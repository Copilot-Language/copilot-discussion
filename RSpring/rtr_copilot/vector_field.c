#define PARAMS 4
#define PENDULUM "PENDULUM"
#define VANDERPOL "VANDERPOL"

#include "pendulum_vector_field.h"
#include "vanderpol_vector_field.h"

#include <string.h>
#include <stdlib.h>

void clear_hyperPoint(double * const hyperPoint, const int NUM_STATES)
{
	for(int i = 0; i < NUM_STATES; ++i)
	{
		hyperPoint[i] = 0.0;
	}
}

void build_vector_field(const int xaxis, 
		const int yaxis, 
		double * const hyperPoint, 
		const struct Interval * const STATE_BOUNDS, 
		const int NUM_STATES, 
		const double SAMPLES,
	       	const double STEP,
	       	derivativeFunDef derivative)
{
	assert(xaxis >= 0);
	assert(yaxis >= 0);
	assert(xaxis < NUM_STATES);
	assert(yaxis < NUM_STATES);

	double xrange = STATE_BOUNDS[xaxis].max - STATE_BOUNDS[xaxis].min;
	double xstep = xrange / SAMPLES;

	double yrange = STATE_BOUNDS[yaxis].max - STATE_BOUNDS[yaxis].min;
	double ystep = yrange / SAMPLES;

	for(double i = 0; i < SAMPLES; ++i)
	{
		for(double j = 0; j < SAMPLES; ++j)
		{
			clear_hyperPoint(hyperPoint, NUM_STATES);
			hyperPoint[xaxis] = STATE_BOUNDS[xaxis].min + i * xstep;
			hyperPoint[yaxis] = STATE_BOUNDS[yaxis].min + j * ystep;
			printf("[%f %f]\t", hyperPoint[xaxis], hyperPoint[yaxis]);

			double xdiv = derivative(xaxis, hyperPoint);
			double ydiv = derivative(yaxis, hyperPoint);

			hyperPoint[xaxis] += STEP * xdiv;
			hyperPoint[yaxis] += STEP * ydiv;
			printf("[%f %f]\n", hyperPoint[xaxis], hyperPoint[yaxis]);
		}
	}
}

int main(int argv, char** argc)
{
	const int xaxis = (argv >= PARAMS) ? atoi(argc[2]) : 0;
	const int yaxis = (argv >= PARAMS) ? atoi(argc[3]) : 1;

	if(argv < PARAMS-2)
	{
		printf("Missing RTR Monitor Type Parameter\n");
	}
	else if(!strcmp(PENDULUM, argc[1]))
	{
		build_vector_field(xaxis, yaxis, pendulum_hyperPoint, PENDULUM_STATE_BOUNDS, PENDULUM_NUM_STATES, PENDULUM_SAMPLES, PENDULUM_STEP, &pendulum_derivative);
	}
	else if(!strcmp(VANDERPOL, argc[1]))
	{
		build_vector_field(xaxis, yaxis, vanderpol_hyperPoint, VANDERPOL_STATE_BOUNDS, VANDERPOL_NUM_STATES, VANDERPOL_SAMPLES, VANDERPOL_STEP, &vanderpol_derivative);
	}
	return 0;
}
