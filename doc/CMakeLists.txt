INCLUDE(../cmakemodules/AssureCMakeRootFile.cmake) # Avoid user mistake in CMake source directory


# Dummy documentation target for showing grouped files in IDEs:
# ----------------------------------------------------------------------------
FILE(GLOB DOX_HDRS "${CMAKE_SOURCE_DIR}/doc/doxygen-pages/*.h")
FILE(GLOB_RECURSE RST_FILES "${CMAKE_SOURCE_DIR}/doc/*.rst")
SET(DOC_INDIV_FILES
	"${CMAKE_SOURCE_DIR}/README.md"
	)
SET(all_docs_files ${DOX_HDRS} ${RST_FILES} ${DOC_INDIV_FILES})
add_custom_target(DocumentationFiles DEPENDS ${all_docs_files} SOURCES ${all_docs_files})
set_target_properties(DocumentationFiles PROPERTIES FOLDER "documentation")

# ----------------------------------------------------------------------------
# Targets for building the documentation of the MRPT
# ----------------------------------------------------------------------------

PROJECT(documentation)

IF(UNIX)
	add_subdirectory(man-pages)
ENDIF()

FIND_PACKAGE(Doxygen)

# --------------------------------
# documentation_performance_html
# --------------------------------
if(TARGET mrpt-perfdata2html)
	SET(PERF2HTML_GENERATED_EXE "$<TARGET_FILE:mrpt-perfdata2html>")
	add_custom_target(documentation_performance_html
		COMMAND 		${PERF2HTML_GENERATED_EXE} "${MRPT_SOURCE_DIR}/doc/perf-data/"
		WORKING_DIRECTORY	${MRPT_SOURCE_DIR}/
		COMMENT 		"Generating performance HTML pages"
		)
	add_dependencies(documentation_performance_html mrpt-perfdata2html)
	set_target_properties(documentation_performance_html PROPERTIES FOLDER "documentation")
endif()

if(DOXYGEN_EXECUTABLE)
	# --------------------------------
	#   documentation_html
	# --------------------------------
	add_custom_target(documentation_html
		COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/build.py ${MRPT_VERSION}
		COMMENT "Generating MRPT documentation (html)"
		SOURCES build.py conf.py _templates/layout.html ${RST_FILES}
		)
	set_target_properties(documentation_html PROPERTIES FOLDER "documentation")
endif()


# Compile Latex targets:
if(NOT WIN32)
find_program(LATEXMK_PROGRAM latexmk)
mark_as_advanced(LATEXMK_PROGRAM)
if(LATEXMK_PROGRAM)
	# The main (empty) target:
	add_custom_target(documentation_psgz_guides)

    # pbmap-guide
	add_custom_target(documentation_pbmap-guide
		COMMAND 		make -C ${MRPT_SOURCE_DIR}/doc/pbmap-guide/ pbmap-guide.ps.gz
		COMMENT 		"Generating pbmap-guide (ps.gz)"
		)
	add_dependencies(documentation_psgz_guides documentation_pbmap-guide)

	# graphslam-engine-guide
	add_custom_target(documentation_graphslam-engine-guide
		COMMAND 		make -C ${MRPT_SOURCE_DIR}/doc/graphslam-engine-guide/ graphslam-engine-guide.ps.gz
		COMMENT 		"Generating graphslam-engine-guide (ps.gz)"
		)
	add_dependencies(documentation_psgz_guides documentation_graphslam-engine-guide)

endif()
endif()
