#ifndef _HYPER_RECT_H_
#define _HYPER_RECT_H_

#include "interval.h"

struct HyperRect
{
	struct Interval * const dims;
};

#endif // _HYPER_RECT_H_
