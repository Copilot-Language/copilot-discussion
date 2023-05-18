#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include "sonar_types.h"
#include "sonar.h"

static int32_t distance_cpy;

bool out_of_range_guard(void) {
  return (distance_cpy) > ((int32_t)(18));
}

int32_t out_of_range_arg0(void) {
  return distance_cpy;
}

void step(void) {
  int32_t out_of_range_arg_temp0;
  (distance_cpy) = (distance);
  if ((out_of_range_guard)()) {
    {(out_of_range_arg_temp0) = ((out_of_range_arg0)());
     (out_of_range)((out_of_range_arg_temp0));}
  };
}
