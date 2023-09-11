#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include "heater_types.h"
#include "heater.h"

static uint8_t temperature_cpy;

bool heaton_guard(void) {
/*low level c code */
}

float heaton_arg0(void) {
/*low level c code */
}

bool heatoff_guard(void) {
/*low level c code */
}

float heatoff_arg0(void) {
/*low level c code */
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
