#include "interval.h"

bool contains(struct Interval* intv, double value)
{
	return (intv->min <= value) && (intv->max >= value);
}

double avg(struct Interval* intv)
{
	return ((intv->max + intv->min) / 2.0);
}
