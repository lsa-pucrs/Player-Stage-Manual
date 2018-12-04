CMAKE_MINIMUM_REQUIRED (VERSION 2.8 FATAL_ERROR)
message(STATUS "Configuring soxplayer")

#########
# check depedencies - libsox
#########
find_path( LSOX_INCLUDE_DIR sox.h DOC "Libsox include dir" )
find_library( LSOX_LIB 
	NAMES sox 
	HINTS /usr/lib/x86_64-linux-gnu/ /usr/lib/arm-linux-gnueabihf
	DOC "Libsox lib" REQUIRED)

IF( NOT LSOX_LIB )
  MESSAGE( FATAL_ERROR "libSoX not found. Please install 'sudo apt-get install libsox-dev'. aborting" )
ENDIF()
message(STATUS "SoX Library -- ${LSOX_LIB}")
message(STATUS "SoX Include -- ${LSOX_INCLUDE_DIR}")

#########
# set Player cmake modules
#########
# add the cmake path for player
SET (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "/usr/local/share/cmake/Modules")
#SET (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "/opt/player/share/cmake/Modules/")
INCLUDE (UsePlayerPlugin)

PLAYER_ADD_PLUGIN_DRIVER (soxplayer SOURCES soxplayer.cc) 
TARGET_LINK_LIBRARIES (soxplayer ${LSOX_LIB}) 
INCLUDE_DIRECTORIES (${CMAKE_CURRENT_SOURCE_DIR} ${LSOX_INCLUDE_DIR})
