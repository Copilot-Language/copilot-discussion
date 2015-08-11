#include "nonlinear_pendulum_params.h"
#include <math.h>
#include <float.h>

#define G 9.81
#define l 0.3
#define m 0.25
#define M 0.5

double control_action(double* state)
{
	static const double KP = 25.0;
	static const double KD = 5.0;
	//static const double KP = 0.0;
	//static const double KD = 0.0;
	return KP * state[1] + KD * state[3];
}

double pos_derivative(double* state)
{
	return state[2];
}

double theta_derivative(double* state)
{
	return state[3];
}

double vel_derivative(double* state)
{
	double u = control_action(state);
	double dt2_num = u + m * l * sin(state[1]) * pow(state[3], 2.0) - m * G * cos(state[1]) * sin(state[1]);
	double dt2_den = M + m - m * pow(cos(state[1]), 2.0);
	return dt2_num / dt2_den;
}

double omega_derivative(double* state)
{
	double u = control_action(state);
	double dt3_num = u * cos(state[1]) - (M+m) * G * sin(state[1]) + m * l * (cos(state[1]) * sin(state[1])) * state[3];
	double dt3_den = m * l * pow(cos(state[1]), 2.0) - (M+m) * l;
	return dt3_num / dt3_den;
}

double nonlinear_pendulum_derivative(int dim, double* state)
{
	switch(dim)
	{
		case 0:
			{
				return pos_derivative(state);
			}
		case 1:
			{
				return theta_derivative(state);
			}
		case 2:
			{
				return vel_derivative(state);
			}
		case 3:
			{
				return omega_derivative(state);
			}
		default:
			{
				return 0.0;
			}
	}
}

void nonlinear_pendulum_updateInflectionPoints(struct Interval* rv, int dim, struct HyperRect* box)
{
	// TODO Calulate Inflection Points for Nonlinear Pendulum
}
