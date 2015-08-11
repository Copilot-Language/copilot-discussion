#ifndef _MONITOR_H_
#define _MONITOR_H_

#include "hyper_rect.h"

typedef double (*derivativeFunDef)(int dim, double* state);
typedef void (*UIPFunDef)(struct Interval* rv, int dim, struct HyperRect* box);

struct Monitor
{
	const unsigned NUM_STATES;
	const double reachTimeStep;
	const struct Interval * const state_constraints;
	derivativeFunDef derivative;
	UIPFunDef updateInflectionPoints;
	struct HyperRect * const rset;
	struct HyperRect * const neighborhood;
};

#endif // _MONITOR_H_
