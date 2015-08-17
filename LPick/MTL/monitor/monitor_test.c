#include "copilot-c99-codegen/copilot.h"
#include "triggers.h"
#include <stdio.h>
#include <inttypes.h>

// externs
uint64_t clk_nanosec = 0;
bool stall_warning = false;
bool afterburner_on = false;
double airspeed = 0;
double max_airspeed = 2;
bool takeoff = false;
float pitch_deg = 0;
double altitude_ft = 0;

void to_monitor (void) {
  for (clk_nanosec = 0; clk_nanosec < 600000000000; clk_nanosec += 100000000) {
    takeoff = false;
    // takeoff
    if (clk_nanosec < 30000000000) {
      airspeed += 0.00025;
      if (clk_nanosec > 2000000000) {
        pitch_deg += 0.1;
      }
    }
    else if (clk_nanosec < 48000000000) {
      airspeed += 0.0025;
      pitch_deg += 0.0025;
    }
    else if (clk_nanosec == 52000000000) {
      takeoff = true;
      printf("%" PRId64 ": Takeoff\n", clk_nanosec);
      altitude_ft += 0.5;
    }
    else if (clk_nanosec < 66000000000) {
      airspeed += 0.025;
      altitude_ft += 3;
    }
    else if (clk_nanosec < 90000000000) {
      pitch_deg += 0.005;
      altitude_ft += 5.5;
    }
    // stall
    else if (clk_nanosec < 126000000000) {
      pitch_deg += 0.01;
    }
    // afterburner
    else if (clk_nanosec < 145000000000) {
      afterburner_on = true;
      airspeed += 0.25;
      pitch_deg -= 0.1;
    }
    else if (clk_nanosec < 168000000000){
      afterburner_on = false;
      altitude_ft += 2.5;
    }
    else if (clk_nanosec < 170000000000){
      afterburner_on = true;
      airspeed += 0.005;
      altitude_ft += 3.5;
    }

    // stall warning alarm
    if (pitch_deg >= 16) {
      stall_warning = true;
      airspeed -= 0.06;
    }
    else {
      stall_warning = false;
    }
    step();
    
  }
}

int main (void) {
  to_monitor();
  return 0;
}
