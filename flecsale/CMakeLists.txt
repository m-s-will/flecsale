#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

################################################################################
# Please Do Not Edit This File Unless You Know What You Are Doing!!!
#
# Project-specific configuration rules should be added in the 'config'
# subdirectory of the top-level of this project in the appropriate file,
# e.g., package configuration options should go in 'config/packages.cmake'.
#
# For more documentation on the design philosophy of this build system
# and the recognized configuration files that can be added to the 'config'
# subdirectory, please look in 'cinch/README.md' and 'cinch/INSTALL.md'
# from the top-level of this project.
#
# Any changes to the basic build template should be discussed with the
# project maintainers.
################################################################################

#------------------------------------------------------------------------------#
# Require some version of cmake
#------------------------------------------------------------------------------#

cmake_minimum_required(VERSION 2.8)

#------------------------------------------------------------------------------#
# Include project-level CMake configuration file
#------------------------------------------------------------------------------#

option(USE_CATALYST "Link the sim with Catalyst for in situ" OFF)

if (USE_CATALYST)
  	find_package(ParaView REQUIRED COMPONENTS vtkPVPythonCatalyst)
    include("${PARAVIEW_USE_FILE}")

    add_definitions("-DUSE_CATALYST")

    include ( "${ParaView_DIR}/VTK/VTKConfig.cmake" )
    add_definitions( -DHAVE_VTK )
	set(VTK_FOUND ON CACHE BOOL "Link to VTK")
	set(VTK_INCLUDED ON CACHE BOOL "Link to VTK")
endif()

if(NOT "$ENV{CINCH_SOURCE_DIR}" STREQUAL "")
    set(CINCH_SOURCE_DIR $ENV{CINCH_SOURCE_DIR})
elseif(EXISTS ${CMAKE_SOURCE_DIR}/cinch)
    set(CINCH_SOURCE_DIR ${CMAKE_SOURCE_DIR}/cinch)
endif()

include(${CINCH_SOURCE_DIR}/cmake/ProjectLists.txt)
