#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include "heater2_types.h"
#include "heater2.h"

static uint8_t temperature_cpy;

bool heaton_guard(void) {
  return ((((float)(temperature_cpy)) * (((float)(150.0f)) / ((float)(255.0f)))) - ((float)(50.0f))) < ((float)(18.0f));
}

float heaton_arg0(void) {
  return (((float)(temperature_cpy)) * (((float)(150.0f)) / ((float)(255.0f)))) - ((float)(50.0f));
}

bool heatoff_guard(void) {
  return ((((float)(temperature_cpy)) * (((float)(150.0f)) / ((float)(255.0f)))) - ((float)(50.0f))) > ((float)(21.0f));
}

float heatoff_arg0(void) {
  return (((float)(temperature_cpy)) * (((float)(150.0f)) / ((float)(255.0f)))) - ((float)(50.0f));
}

void step(void) {
  float heaton_arg_temp0;
  float heatoff_arg_temp0;
  (temperature_cpy) = (temperature);
  if ((heaton_guard)()) {
    {(heaton_arg_temp0) = ((heaton_arg0)());
     (heaton)((heaton_arg_temp0));}
  };
  if ((heatoff_guard)()) {
    {(heatoff_arg_temp0) = ((heatoff_arg0)());
     (heatoff)((heatoff_arg_temp0));}
  };
}
