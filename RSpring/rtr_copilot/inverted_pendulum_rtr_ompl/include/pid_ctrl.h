#ifndef PID_CTRL_
#define PID_CTRL_

#include "ompl/control/planners/PlannerIncludes.h"
#include <vector>
#include <limits>
#include <math.h>

namespace ompl
{

	namespace control
	{

		class PID : public base::Planner
		{
			public:

				/** \brief Constructor */
				PID(const SpaceInformationPtr &si);

				virtual ~PID(void);

				/** \brief Continue solving for some amount of time. Return true if solution was found. */
				virtual base::PlannerStatus solve(const base::PlannerTerminationCondition &ptc);

				/** \brief Clear datastructures. Call this function if the
				  input data to the planner has changed and you do not
				  want to continue planning */
				virtual void clear(void);

				virtual void getPlannerData(base::PlannerData &data) const;

				virtual void setup(void);
			protected:


				/** \brief Representation of a motion

				  This only contains pointers to parent motions as we
				  only need to go backwards in the tree. */
				class Motion
				{
					public:

						Motion(void) : state(NULL), control(NULL) {}

						/** \brief Constructor that allocates memory for the state and the control */
						Motion(const SpaceInformation *si) : state(si->allocState()), control(si->allocControl()) {}

						~Motion(void) {}

						/** \brief The state contained by the motion */
						base::State       *state;

						/** \brief The control contained by the motion */
						Control           *control;
				};

				void control_action(Control*& control, base::State*& state);

				/** \brief State sampler */
				base::StateSamplerPtr                          sampler_;

				/** \brief Control sampler */
				DirectedControlSamplerPtr                      controlSampler_;

				/** \brief The base::SpaceInformation cast as control::SpaceInformation, for convenience */
				const SpaceInformation                        *siC_;

				/** \brief List of PID motions **/
				std::vector<Motion*> motions;

				const double EPSILON = 0.1;
		};
	}
}

#endif
