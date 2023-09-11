#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include "backup_monitor_types.h"
#include "backup_monitor.h"

static int32_t distance_cpy;

bool green_guard(void) {
  return (distance_cpy) > ((int32_t)(18));
}

int32_t green_arg0(void) {
  return distance_cpy;
}

bool yellow_guard(void) {
  return (((int32_t)(18)) >= (distance_cpy)) && ((distance_cpy) > ((int32_t)(6)));
}

int32_t yellow_arg0(void) {
  return distance_cpy;
}

bool red_guard(void) {
  return (distance_cpy) <= ((int32_t)(6));
}

int32_t red_arg0(void) {
  return distance_cpy;
}

void step(void) {
  int32_t green_arg_temp0;
  int32_t yellow_arg_temp0;
  int32_t red_arg_temp0;
  (distance_cpy) = (distance);
  if ((green_guard)()) {
    {(green_arg_temp0) = ((green_arg0)());
     (green)((green_arg_temp0));}
  };
  if ((yellow_guard)()) {
    {(yellow_arg_temp0) = ((yellow_arg0)());
     (yellow)((yellow_arg_temp0));}
  };
  if ((red_guard)()) {
    {(red_arg_temp0) = ((red_arg0)());
     (red)((red_arg_temp0));}
  };
}
