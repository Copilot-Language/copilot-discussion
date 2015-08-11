#ifndef INPUT_H
#define INPUT_H

#include "linear.h"
#include <stdbool.h>

static double bound(struct Interval i, double value);
static void check_input(struct LinearParams * const params, double* values);
void generate_input(struct LinearParams * const params, double* state);

#endif // INPUT_H
