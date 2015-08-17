#include "test_copilot-c99-codegen/test_copilot.h"
#include <stdio.h>
int iters = 30;

void err (char* functionName, int32_t clk, bool expected) {
  printf("Problem at time %d with function %s: expected %d\n", clk, functionName, expected);
}

int main (void) {
  int i;
  for (i = 0; i < iters; i++) {
    test_step();
    if (! test_eventually_match9) {
      err("eventually9", test_clk9, test_eventually_expected9);
    }
    if (! test_eventually_match8) {
      err("eventually8", test_clk8, test_eventually_expected8);
    }
    if (! test_eventually_match7) {
      err("eventually7", test_clk7, test_eventually_expected7);
    }
    if (! test_eventually_match6) {
      err("eventually6", test_clk6, test_eventually_expected6);
    }
    if (! test_eventually_match5) {
      err("eventually5", test_clk5, test_eventually_expected5);
    }
    if (! test_eventually_match4) {
      err("eventually4", test_clk4, test_eventually_expected4);
    }
    if (! test_eventually_match3) {
      err("eventually3", test_clk3, test_eventually_expected3);
    }
    if (! test_eventually_match2) {
      err("eventually2", test_clk2, test_eventually_expected2);
    }
    if (! test_eventually_match1) {
      err("eventually1", test_clk1, test_eventually_expected1);
    }
    if (! test_eventually_match0) {
      err("eventually0", test_clk0, test_eventually_expected0);
    }
    if (! test_eventuallyPrev_match9) {
      err("eventuallyPrev9", test_clk9, test_eventuallyPrev_expected9);
    }
    if (! test_eventuallyPrev_match8) {
      err("eventuallyPrev8", test_clk8, test_eventuallyPrev_expected8);
    }
    if (! test_eventuallyPrev_match7) {
      err("eventuallyPrev7", test_clk7, test_eventuallyPrev_expected7);
    }
    if (! test_eventuallyPrev_match6) {
      err("eventuallyPrev6", test_clk6, test_eventuallyPrev_expected6);
    }
    if (! test_eventuallyPrev_match5) {
      err("eventuallyPrev5", test_clk5, test_eventuallyPrev_expected5);
    }
    if (! test_eventuallyPrev_match4) {
      err("eventuallyPrev4", test_clk4, test_eventuallyPrev_expected4);
    }
    if (! test_eventuallyPrev_match3) {
      err("eventuallyPrev3", test_clk3, test_eventuallyPrev_expected3);
    }
    if (! test_eventuallyPrev_match2) {
      err("eventuallyPrev2", test_clk2, test_eventuallyPrev_expected2);
    }
    if (! test_eventuallyPrev_match1) {
      err("eventuallyPrev1", test_clk1, test_eventuallyPrev_expected1);
    }
    if (! test_eventuallyPrev_match0) {
      err("eventuallyPrev0", test_clk0, test_eventuallyPrev_expected0);
    }
    if (! test_always_match9) {
      err("always9", test_clk9, test_always_expected9);
    }
    if (! test_always_match8) {
      err("always8", test_clk8, test_always_expected8);
    }
    if (! test_always_match7) {
      err("always7", test_clk7, test_always_expected7);
    }
    if (! test_always_match6) {
      err("always6", test_clk6, test_always_expected6);
    }
    if (! test_always_match5) {
      err("always5", test_clk5, test_always_expected5);
    }
    if (! test_always_match4) {
      err("always4", test_clk4, test_always_expected4);
    }
    if (! test_always_match3) {
      err("always3", test_clk3, test_always_expected3);
    }
    if (! test_always_match2) {
      err("always2", test_clk2, test_always_expected2);
    }
    if (! test_always_match1) {
      err("always1", test_clk1, test_always_expected1);
    }
    if (! test_always_match0) {
      err("always0", test_clk0, test_always_expected0);
    }
    if (! test_alwaysBeen_match9) {
      err("alwaysBeen9", test_clk9, test_alwaysBeen_expected9);
    }
    if (! test_alwaysBeen_match8) {
      err("alwaysBeen8", test_clk8, test_alwaysBeen_expected8);
    }
    if (! test_alwaysBeen_match7) {
      err("alwaysBeen7", test_clk7, test_alwaysBeen_expected7);
    }
    if (! test_alwaysBeen_match6) {
      err("alwaysBeen6", test_clk6, test_alwaysBeen_expected6);
    }
    if (! test_alwaysBeen_match5) {
      err("alwaysBeen5", test_clk5, test_alwaysBeen_expected5);
    }
    if (! test_alwaysBeen_match4) {
      err("alwaysBeen4", test_clk4, test_alwaysBeen_expected4);
    }
    if (! test_alwaysBeen_match3) {
      err("alwaysBeen3", test_clk3, test_alwaysBeen_expected3);
    }
    if (! test_alwaysBeen_match2) {
      err("alwaysBeen2", test_clk2, test_alwaysBeen_expected2);
    }
    if (! test_alwaysBeen_match1) {
      err("alwaysBeen1", test_clk1, test_alwaysBeen_expected1);
    }
    if (! test_alwaysBeen_match0) {
      err("alwaysBeen0", test_clk0, test_alwaysBeen_expected0);
    }
    if (! test_until_match9) {
      err("until9", test_clk9, test_until_expected9);
    }
    if (! test_until_match8) {
      err("until8", test_clk8, test_until_expected8);
    }
    if (! test_until_match7) {
      err("until7", test_clk7, test_until_expected7);
    }
    if (! test_until_match6) {
      err("until6", test_clk6, test_until_expected6);
    }
    if (! test_until_match5) {
      err("until5", test_clk5, test_until_expected5);
    }
    if (! test_until_match4) {
      err("until4", test_clk4, test_until_expected4);
    }
    if (! test_until_match3) {
      err("until3", test_clk3, test_until_expected3);
    }
    if (! test_until_match2) {
      err("until2", test_clk2, test_until_expected2);
    }
    if (! test_until_match1) {
      err("until1", test_clk1, test_until_expected1);
    }
    if (! test_until_match0) {
      err("until0", test_clk0, test_until_expected0);
    }
    if (! test_since_match9) {
      err("since9", test_clk9, test_since_expected9);
    }
    if (! test_since_match8) {
      err("since8", test_clk8, test_since_expected8);
    }
    if (! test_since_match7) {
      err("since7", test_clk7, test_since_expected7);
    }
    if (! test_since_match6) {
      err("since6", test_clk6, test_since_expected6);
    }
    if (! test_since_match5) {
      err("since5", test_clk5, test_since_expected5);
    }
    if (! test_since_match4) {
      err("since4", test_clk4, test_since_expected4);
    }
    if (! test_since_match3) {
      err("since3", test_clk3, test_since_expected3);
    }
    if (! test_since_match2) {
      err("since2", test_clk2, test_since_expected2);
    }
    if (! test_since_match1) {
      err("since1", test_clk1, test_since_expected1);
    }
    if (! test_since_match0) {
      err("since0", test_clk0, test_since_expected0);
    }
    if (! test_release_match9) {
      err("release9", test_clk9, test_release_expected9);
    }
    if (! test_release_match8) {
      err("release8", test_clk8, test_release_expected8);
    }
    if (! test_release_match7) {
      err("release7", test_clk7, test_release_expected7);
    }
    if (! test_release_match6) {
      err("release6", test_clk6, test_release_expected6);
    }
    if (! test_release_match5) {
      err("release5", test_clk5, test_release_expected5);
    }
    if (! test_release_match4) {
      err("release4", test_clk4, test_release_expected4);
    }
    if (! test_release_match3) {
      err("release3", test_clk3, test_release_expected3);
    }
    if (! test_release_match2) {
      err("release2", test_clk2, test_release_expected2);
    }
    if (! test_release_match1) {
      err("release1", test_clk1, test_release_expected1);
    }
    if (! test_release_match0) {
      err("release0", test_clk0, test_release_expected0);
    }
    if (! test_trigger_match9) {
      err("trigger9", test_clk9, test_trigger_expected9);
    }
    if (! test_trigger_match8) {
      err("trigger8", test_clk8, test_trigger_expected8);
    }
    if (! test_trigger_match7) {
      err("trigger7", test_clk7, test_trigger_expected7);
    }
    if (! test_trigger_match6) {
      err("trigger6", test_clk6, test_trigger_expected6);
    }
    if (! test_trigger_match5) {
      err("trigger5", test_clk5, test_trigger_expected5);
    }
    if (! test_trigger_match4) {
      err("trigger4", test_clk4, test_trigger_expected4);
    }
    if (! test_trigger_match3) {
      err("trigger3", test_clk3, test_trigger_expected3);
    }
    if (! test_trigger_match2) {
      err("trigger2", test_clk2, test_trigger_expected2);
    }
    if (! test_trigger_match1) {
      err("trigger1", test_clk1, test_trigger_expected1);
    }
    if (! test_trigger_match0) {
      err("trigger0", test_clk0, test_trigger_expected0);
    }
    if (! test_matchingUntil_match9) {
      err("matchingUntil9", test_clk9, test_matchingUntil_expected9);
    }
    if (! test_matchingUntil_match8) {
      err("matchingUntil8", test_clk8, test_matchingUntil_expected8);
    }
    if (! test_matchingUntil_match7) {
      err("matchingUntil7", test_clk7, test_matchingUntil_expected7);
    }
    if (! test_matchingUntil_match6) {
      err("matchingUntil6", test_clk6, test_matchingUntil_expected6);
    }
    if (! test_matchingUntil_match5) {
      err("matchingUntil5", test_clk5, test_matchingUntil_expected5);
    }
    if (! test_matchingUntil_match4) {
      err("matchingUntil4", test_clk4, test_matchingUntil_expected4);
    }
    if (! test_matchingUntil_match3) {
      err("matchingUntil3", test_clk3, test_matchingUntil_expected3);
    }
    if (! test_matchingUntil_match2) {
      err("matchingUntil2", test_clk2, test_matchingUntil_expected2);
    }
    if (! test_matchingUntil_match1) {
      err("matchingUntil1", test_clk1, test_matchingUntil_expected1);
    }
    if (! test_matchingUntil_match0) {
      err("matchingUntil0", test_clk0, test_matchingUntil_expected0);
    }
    if (! test_matchingSince_match9) {
      err("matchingSince9", test_clk9, test_matchingSince_expected9);
    }
    if (! test_matchingSince_match8) {
      err("matchingSince8", test_clk8, test_matchingSince_expected8);
    }
    if (! test_matchingSince_match7) {
      err("matchingSince7", test_clk7, test_matchingSince_expected7);
    }
    if (! test_matchingSince_match6) {
      err("matchingSince6", test_clk6, test_matchingSince_expected6);
    }
    if (! test_matchingSince_match5) {
      err("matchingSince5", test_clk5, test_matchingSince_expected5);
    }
    if (! test_matchingSince_match4) {
      err("matchingSince4", test_clk4, test_matchingSince_expected4);
    }
    if (! test_matchingSince_match3) {
      err("matchingSince3", test_clk3, test_matchingSince_expected3);
    }
    if (! test_matchingSince_match2) {
      err("matchingSince2", test_clk2, test_matchingSince_expected2);
    }
    if (! test_matchingSince_match1) {
      err("matchingSince1", test_clk1, test_matchingSince_expected1);
    }
    if (! test_matchingSince_match0) {
      err("matchingSince0", test_clk0, test_matchingSince_expected0);
    }
    if (! test_matchingRelease_match9) {
      err("matchingRelease9", test_clk9, test_matchingRelease_expected9);
    }
    if (! test_matchingRelease_match8) {
      err("matchingRelease8", test_clk8, test_matchingRelease_expected8);
    }
    if (! test_matchingRelease_match7) {
      err("matchingRelease7", test_clk7, test_matchingRelease_expected7);
    }
    if (! test_matchingRelease_match6) {
      err("matchingRelease6", test_clk6, test_matchingRelease_expected6);
    }
    if (! test_matchingRelease_match5) {
      err("matchingRelease5", test_clk5, test_matchingRelease_expected5);
    }
    if (! test_matchingRelease_match4) {
      err("matchingRelease4", test_clk4, test_matchingRelease_expected4);
    }
    if (! test_matchingRelease_match3) {
      err("matchingRelease3", test_clk3, test_matchingRelease_expected3);
    }
    if (! test_matchingRelease_match2) {
      err("matchingRelease2", test_clk2, test_matchingRelease_expected2);
    }
    if (! test_matchingRelease_match1) {
      err("matchingRelease1", test_clk1, test_matchingRelease_expected1);
    }
    if (! test_matchingRelease_match0) {
      err("matchingRelease0", test_clk0, test_matchingRelease_expected0);
    }
    if (! test_matchingTrigger_match9) {
      err("matchingTrigger9", test_clk9, test_matchingTrigger_expected9);
    }
    if (! test_matchingTrigger_match8) {
      err("matchingTrigger8", test_clk8, test_matchingTrigger_expected8);
    }
    if (! test_matchingTrigger_match7) {
      err("matchingTrigger7", test_clk7, test_matchingTrigger_expected7);
    }
    if (! test_matchingTrigger_match6) {
      err("matchingTrigger6", test_clk6, test_matchingTrigger_expected6);
    }
    if (! test_matchingTrigger_match5) {
      err("matchingTrigger5", test_clk5, test_matchingTrigger_expected5);
    }
    if (! test_matchingTrigger_match4) {
      err("matchingTrigger4", test_clk4, test_matchingTrigger_expected4);
    }
    if (! test_matchingTrigger_match3) {
      err("matchingTrigger3", test_clk3, test_matchingTrigger_expected3);
    }
    if (! test_matchingTrigger_match2) {
      err("matchingTrigger2", test_clk2, test_matchingTrigger_expected2);
    }
    if (! test_matchingTrigger_match1) {
      err("matchingTrigger1", test_clk1, test_matchingTrigger_expected1);
    }
    if (! test_matchingTrigger_match0) {
      err("matchingTrigger0", test_clk0, test_matchingTrigger_expected0);
    }
  }
  printf("Test completed.\n");
  return 0;
}