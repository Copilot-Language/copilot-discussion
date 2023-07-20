#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include "sonar_types.h"
#include "sonar.h"

static int32_t distance_cpy;

bool low_range_guard(void) {
  return ((int32_t)(10)) < (distance_cpy);
}

int32_t low_range_arg0(void) {
  return distance_cpy;
}

bool out_of_bounds_guard(void) {
  return (((int32_t)(10)) < (distance_cpy)) && ((distance_cpy) < ((int32_t)(18)));
}

int32_t out_of_bounds_arg0(void) {
  return distance_cpy;
}

bool upper_bound_guard(void) {
  return (distance_cpy) < ((int32_t)(18));
}

int32_t upper_bound_arg0(void) {
  return distance_cpy;
}

void step(void) {
  int32_t low_range_arg_temp0;
  int32_t out_of_bounds_arg_temp0;
  int32_t upper_bound_arg_temp0;
  (distance_cpy) = (distance);
  if ((low_range_guard)()) {
    {(low_range_arg_temp0) = ((low_range_arg0)());
     (low_range)((low_range_arg_temp0));}
  };
  if ((out_of_bounds_guard)()) {
    {(out_of_bounds_arg_temp0) = ((out_of_bounds_arg0)());
     (out_of_bounds)((out_of_bounds_arg_temp0));}
  };
  if ((upper_bound_guard)()) {
    {(upper_bound_arg_temp0) = ((upper_bound_arg0)());
     (upper_bound)((upper_bound_arg_temp0));}
  };
}
