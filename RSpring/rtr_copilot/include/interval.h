#ifndef _INTERVAL_H_
#define _INTERVAL_H_

#include <stdbool.h>

struct Interval
{
	double min;
	double max;
};

bool contains(struct Interval* intv, double value);
double avg(struct Interval* intv);
#endif // _INTERVAL_H_
