CMAKE_MINIMUM_REQUIRED (VERSION 2.8 FATAL_ERROR)
PROJECT (soxplayer-test)

# Include this CMake module to get most of the settings needed to build
SET (CMAKE_MODULE_PATH "/usr/local/share/cmake/Modules")
#SET (CMAKE_MODULE_PATH "/opt/player/share/cmake/Modules/")

INCLUDE (UsePlayerC++)

PLAYER_ADD_PLAYERCPP_CLIENT (soxplayer-test SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/soxplayer-test.cc)
