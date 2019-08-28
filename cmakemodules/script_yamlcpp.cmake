# Check for yaml-cpp libray.
# It has a *-config.cmake files, but they are not present in Ubuntu 12.04 LTS,
# so we use pkg-config there.
# ===================================================
set(CMAKE_MRPT_HAS_YAMLCPP 0)
set(CMAKE_MRPT_HAS_YAMLCPP_SYSTEM 0)

# DISABLE_YAMLCPP
# ---------------------
option(DISABLE_YAMLCPP "Force not using yamlcpp" "OFF")
mark_as_advanced(DISABLE_YAMLCPP)
if(NOT DISABLE_YAMLCPP)
	FIND_PACKAGE(PkgConfig REQUIRED)
	find_package(yaml_cpp_catkin QUIET)
	if(${yaml_cpp_catkin_FOUND})
		message(STATUS "Found yaml_cpp_catkin, using instead of system library.")
		set(YamlCpp_LIBRARIES ${yaml_cpp_catkin_LIBRARIES})
		set(YamlCpp_INCLUDE_DIRS ${yaml_cpp_catkin_INCLUDE_DIRS})
	else()
		message(STATUS "No yaml_cpp_catkin, using yaml-cpp system library instead.")
		pkg_check_modules(YamlCpp REQUIRED yaml-cpp>=0.5)
	endif()
endif()
