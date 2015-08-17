#include "copilot-c99-codegen/copilot.h"
#include "triggers.h"
#include <inttypes.h>
#include <stdio.h>

void takeoff_altitude_violation (double measured0, uint64_t clk0,
                                 double measured1, uint64_t clk1,
                                 double measured2, uint64_t clk2,
                                 double measured3, uint64_t clk3,
                                 double measured4, uint64_t clk4,
                                 double measured5, uint64_t clk5,
                                 double measured6, uint64_t clk6,
                                 double measured7, uint64_t clk7,
                                 double measured8, uint64_t clk8,
                                 double measured9, uint64_t clk9,
                                 double measured10, uint64_t clk10,
                                 double expected) {
  printf (
    "%" PRId64 ": "
    "Did not reach an altitude of at least %f ft since takeoff 3 minutes ago. Current and past 10 samples:\n"
    "Altitude: %f     Clock: %" PRId64 "\n"
    "Altitude: %f     Clock: %" PRId64 "\n"
    "Altitude: %f     Clock: %" PRId64 "\n"
    "Altitude: %f     Clock: %" PRId64 "\n"
    "Altitude: %f     Clock: %" PRId64 "\n"
    "Altitude: %f     Clock: %" PRId64 "\n"
    "Altitude: %f     Clock: %" PRId64 "\n"
    "Altitude: %f     Clock: %" PRId64 "\n"
    "Altitude: %f     Clock: %" PRId64 "\n"
    "Altitude: %f     Clock: %" PRId64 "\n"
    "Altitude: %f     Clock: %" PRId64 "\n",
    clk10,
    expected,
    measured0, clk0,
    measured1, clk1,
    measured2, clk2,
    measured3, clk3,
    measured4, clk4,
    measured5, clk5,
    measured6, clk6,
    measured7, clk7,
    measured8, clk8,
    measured9, clk9,
    measured10, clk10
  );
}

void airspeed_violation (double measured0, uint64_t clk0,
                         double measured1, uint64_t clk1,
                         double measured2, uint64_t clk2,
                         double measured3, uint64_t clk3,
                         double measured4, uint64_t clk4,
                         double measured5, uint64_t clk5,
                         double measured6, uint64_t clk6,
                         double measured7, uint64_t clk7,
                         double measured8, uint64_t clk8,
                         double measured9, uint64_t clk9,
                         double measured10, uint64_t clk10,
                         double max) {
  printf (
    "%" PRId64 ": "
    "Exceeded the max airspeed %f for a minute. Current and past 10 samples:\n"
    "Airspeed: %f     Clock: %" PRId64 "\n"
    "Airspeed: %f     Clock: %" PRId64 "\n"
    "Airspeed: %f     Clock: %" PRId64 "\n"
    "Airspeed: %f     Clock: %" PRId64 "\n"
    "Airspeed: %f     Clock: %" PRId64 "\n"
    "Airspeed: %f     Clock: %" PRId64 "\n"
    "Airspeed: %f     Clock: %" PRId64 "\n"
    "Airspeed: %f     Clock: %" PRId64 "\n"
    "Airspeed: %f     Clock: %" PRId64 "\n"
    "Airspeed: %f     Clock: %" PRId64 "\n"
    "Airspeed: %f     Clock: %" PRId64 "\n",
    clk10, max,
    measured0, clk0,
    measured1, clk1,
    measured2, clk2,
    measured3, clk3,
    measured4, clk4,
    measured5, clk5,
    measured6, clk6,
    measured7, clk7,
    measured8, clk8,
    measured9, clk9,
    measured10, clk10
  );
}

void afterburner_violation (bool measured0, uint64_t clk0,
                            bool measured1, uint64_t clk1,
                            bool measured2, uint64_t clk2,
                            bool measured3, uint64_t clk3,
                            bool measured4, uint64_t clk4,
                            bool measured5, uint64_t clk5,
                            bool measured6, uint64_t clk6,
                            bool measured7, uint64_t clk7,
                            bool measured8, uint64_t clk8,
                            bool measured9, uint64_t clk9,
                            bool measured10, uint64_t clk10) {
  printf("%" PRId64 ": "
         "Afterburner on before one minute has passed since being turned off. Current and past 10 samples:\n"
         "Afterburner: %s     Clock: %" PRId64 "\n"
         "Afterburner: %s     Clock: %" PRId64 "\n"
         "Afterburner: %s     Clock: %" PRId64 "\n"
         "Afterburner: %s     Clock: %" PRId64 "\n"
         "Afterburner: %s     Clock: %" PRId64 "\n"
         "Afterburner: %s     Clock: %" PRId64 "\n"
         "Afterburner: %s     Clock: %" PRId64 "\n"
         "Afterburner: %s     Clock: %" PRId64 "\n"
         "Afterburner: %s     Clock: %" PRId64 "\n"
         "Afterburner: %s     Clock: %" PRId64 "\n"
         "Afterburner: %s     Clock: %" PRId64 "\n",
         clk10,
         (measured0 ? "On " : "Off"), clk0,
         (measured1 ? "On " : "Off"), clk1,
         (measured2 ? "On " : "Off"), clk2,
         (measured3 ? "On " : "Off"), clk3,
         (measured4 ? "On " : "Off"), clk4,
         (measured5 ? "On " : "Off"), clk5,
         (measured6 ? "On " : "Off"), clk6,
         (measured7 ? "On " : "Off"), clk7,
         (measured8 ? "On " : "Off"), clk8,
         (measured9 ? "On " : "Off"), clk9,
         (measured10 ? "On " : "Off"), clk10
        );
}

void stall_warning_pitch_violation (bool measured0, uint64_t clk0, float pitch0,
                                    bool measured1, uint64_t clk1, float pitch1,
                                    bool measured2, uint64_t clk2, float pitch2,
                                    bool measured3, uint64_t clk3, float pitch3,
                                    bool measured4, uint64_t clk4, float pitch4,
                                    bool measured5, uint64_t clk5, float pitch5,
                                    bool measured6, uint64_t clk6, float pitch6,
                                    bool measured7, uint64_t clk7, float pitch7,
                                    bool measured8, uint64_t clk8, float pitch8,
                                    bool measured9, uint64_t clk9, float pitch9,
                                    bool measured10, uint64_t clk10, float pitch10) {
  printf (
    "%" PRId64 ": "
    "Pitch should be between 0 and 10 degrees within 1 minute of stall warning. Current and past 10 samples:\n"
    "Stall Warning: %s     Clock: %" PRId64 "     Pitch: %f \n"
    "Stall Warning: %s     Clock: %" PRId64 "     Pitch: %f \n"
    "Stall Warning: %s     Clock: %" PRId64 "     Pitch: %f \n"
    "Stall Warning: %s     Clock: %" PRId64 "     Pitch: %f \n"
    "Stall Warning: %s     Clock: %" PRId64 "     Pitch: %f \n"
    "Stall Warning: %s     Clock: %" PRId64 "     Pitch: %f \n"
    "Stall Warning: %s     Clock: %" PRId64 "     Pitch: %f \n"
    "Stall Warning: %s     Clock: %" PRId64 "     Pitch: %f \n"
    "Stall Warning: %s     Clock: %" PRId64 "     Pitch: %f \n"
    "Stall Warning: %s     Clock: %" PRId64 "     Pitch: %f \n"
    "Stall Warning: %s     Clock: %" PRId64 "     Pitch: %f \n",
    clk10,
    (measured0 ? "On " : "Off"), clk0, pitch0,
    (measured1 ? "On " : "Off"), clk1, pitch1,
    (measured2 ? "On " : "Off"), clk2, pitch2,
    (measured3 ? "On " : "Off"), clk3, pitch3,
    (measured4 ? "On " : "Off"), clk4, pitch4,
    (measured5 ? "On " : "Off"), clk5, pitch5,
    (measured6 ? "On " : "Off"), clk6, pitch6,
    (measured7 ? "On " : "Off"), clk7, pitch7,
    (measured8 ? "On " : "Off"), clk8, pitch8,
    (measured9 ? "On " : "Off"), clk9, pitch9,
    (measured10 ? "On " : "Off"), clk10, pitch10
  );
}
