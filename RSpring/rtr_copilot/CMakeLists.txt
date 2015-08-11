cmake_minimum_required (VERSION 2.8)
project (rtr_copilot)

set (CMAKE_C_FLAGS			"-std=c99 -pedantic -g -O0")
set (CMAKE_CXX_FLAGS		"-std=c++11 -pedantic -g -O0")
set (CMAKE_EXE_LINKER_FLAGS "-Wl,-rpath /usr/local/lib/x86_64-linux-gnu")

include_directories ("${PROJECT_SOURCE_DIR}/include")
include_directories (${CMAKE_SOURCE_DIR})

file(GLOB PENDULUM_AUTOGEN_SRC_FILES "pendulum_autogen/*.c")
file(GLOB VANDERPOL_AUTOGEN_SRC_FILES "vanderpol_autogen/*.c")
file(GLOB PROJECT_SRC_FILES "src/*.c")
file(GLOB LINEAR_SRC_FILES "linear_system/*.c")
file(GLOB NONLINEAR_PENDULUM_SRC_FILES "nonlinear_pendulum_autogen/*.c")
file(GLOB OMPL_SRC_FILES "inverted_pendulum_rtr_ompl/*.cpp")

add_executable(rt_reachability ${PENDULUM_AUTOGEN_SRC_FILES} ${LINEAR_SRC_FILES} ${NONLINEAR_PENDULUM_SRC_FILES} ${VANDERPOL_AUTOGEN_SRC_FILES} ${PROJECT_SRC_FILES} rt_reachability.c)
target_include_directories(rt_reachability PUBLIC "${PROJECT_SOURCE_DIR}/linear_system/include")
target_include_directories(rt_reachability PUBLIC "${PROJECT_SOURCE_DIR}/pendulum_autogen/include")
target_include_directories(rt_reachability PUBLIC "${PROJECT_SOURCE_DIR}/nonlinear_pendulum_autogen/include")
target_include_directories(rt_reachability PUBLIC "${PROJECT_SOURCE_DIR}/vanderpol_autogen/include")
target_link_libraries(rt_reachability m)

add_executable(vector_field ${PENDULUM_AUTOGEN_SRC_FILES} ${LINEAR_SRC_FILES} ${VANDERPOL_AUTOGEN_SRC_FILES} ${PROJECT_SRC_FILES} vector_field.c)
target_include_directories(vector_field PUBLIC "${PROJECT_SOURCE_DIR}/linear_system/include")
target_include_directories(vector_field PUBLIC "${PROJECT_SOURCE_DIR}/pendulum_autogen/include")
target_include_directories(vector_field PUBLIC "${PROJECT_SOURCE_DIR}/vanderpol_autogen/include")
target_link_libraries(vector_field m)

set(Boost_USE_STATIC_LIBS OFF)
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_RUNTIME OFF)
find_package(Boost 1.49.0 COMPONENTS system program_options REQUIRED)

add_executable(ompl_rtr_monitor ${OMPL_SRC_FILES} ${NONLINEAR_PENDULUM_SRC_FILES} ${PROJECT_SRC_FILES})
target_include_directories(ompl_rtr_monitor PUBLIC "${PROJECT_SOURCE_DIR}/nonlinear_pendulum_autogen/include")
target_include_directories(ompl_rtr_monitor PUBLIC "${PROJECT_SOURCE_DIR}/inverted_pendulum_rtr_ompl/include")
target_link_libraries (ompl_rtr_monitor
	${Boost_SYSTEM_LIBRARY}
	${Boost_PROGRAM_OPTIONS_LIBRARY}
	ompl
	ompl_app
	ompl_app_base
	)
