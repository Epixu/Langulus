include(FetchContent)

function(fetch_langulus_module NAME GIT_TAG TAG)
    if(NOT DEFINED LANGULUS_EXTERNAL_DIRECTORY)
        set(LANGULUS_EXTERNAL_DIRECTORY "${CMAKE_SOURCE_DIR}/external" CACHE PATH
            "Place where external dependencies will be downloaded")
        message(WARNING "LANGULUS_EXTERNAL_DIRECTORY not defined, using default: ${LANGULUS_EXTERNAL_DIRECTORY}")
    endif()

	# Completely avoid downloading or updating anything, once the appropriate folder exists
	string(TOUPPER ${NAME} UPPERCASE_NAME)
	if (EXISTS "${LANGULUS_EXTERNAL_DIRECTORY}/${NAME}-src")
		set(FETCHCONTENT_SOURCE_DIR_LANGULUS${UPPERCASE_NAME} "${LANGULUS_EXTERNAL_DIRECTORY}/${NAME}-src" CACHE INTERNAL "" FORCE)
		message(STATUS "Reusing external library Langulus::${NAME}... (delete ${LANGULUS_EXTERNAL_DIRECTORY}/${NAME}-src manually in order to redownload)")
	else()
		unset(FETCHCONTENT_SOURCE_DIR_LANGULUS${UPPERCASE_NAME} CACHE)
		message(STATUS "Downloading external library Langulus::${NAME}...")
	endif()

    FetchContent_Declare(
        Langulus${NAME}
        GIT_REPOSITORY  https://github.com/Langulus/${NAME}.git
        GIT_TAG         ${TAG}
        SOURCE_DIR      "${LANGULUS_EXTERNAL_DIRECTORY}/${NAME}-src"
        SUBBUILD_DIR    "${CMAKE_BINARY_DIR}/external/${NAME}-subbuild"
        ${ARGN}
    )
    FetchContent_MakeAvailable(Langulus${NAME})
endfunction()

function(fetch_external_module NAME GIT_REPOSITORY REPO GIT_TAG TAG)
    if(NOT DEFINED LANGULUS_EXTERNAL_DIRECTORY)
        set(LANGULUS_EXTERNAL_DIRECTORY "${CMAKE_SOURCE_DIR}/external" CACHE PATH
            "Place where external dependencies will be downloaded")
        message(WARNING "LANGULUS_EXTERNAL_DIRECTORY not defined, using default: ${LANGULUS_EXTERNAL_DIRECTORY}")
    endif()

	# Completely avoid downloading or updating anything, once the appropriate folder exists
	string(TOUPPER ${NAME} UPPERCASE_NAME)
	if (EXISTS "${LANGULUS_EXTERNAL_DIRECTORY}/${NAME}-src")
		set(FETCHCONTENT_SOURCE_DIR_${UPPERCASE_NAME} "${LANGULUS_EXTERNAL_DIRECTORY}/${NAME}-src" CACHE INTERNAL "" FORCE)
		message(STATUS "Reusing external library ${NAME}... (delete ${LANGULUS_EXTERNAL_DIRECTORY}/${NAME}-src manually in order to redownload)")
	else()
		unset(FETCHCONTENT_SOURCE_DIR_${UPPERCASE_NAME} CACHE)
		message(STATUS "Downloading external library ${NAME}...")
	endif()

    FetchContent_Declare(
        ${NAME}
        GIT_REPOSITORY  ${REPO}
        GIT_TAG         ${TAG}
        SOURCE_DIR      "${LANGULUS_EXTERNAL_DIRECTORY}/${NAME}-src"
        SUBBUILD_DIR    "${CMAKE_BINARY_DIR}/external/${NAME}-subbuild"
        ${ARGN}
		EXCLUDE_FROM_ALL
    )
    FetchContent_MakeAvailable(${NAME})
	
	string(TOLOWER ${NAME} LOWERCASE_NAME)
    set(${NAME}_SOURCE_DIR "${${LOWERCASE_NAME}_SOURCE_DIR}" CACHE INTERNAL "${NAME} source directory")
    set(${NAME}_BINARY_DIR "${${LOWERCASE_NAME}_BINARY_DIR}" CACHE INTERNAL "${NAME} binary directory")
endfunction()

function(langulus_init_git_submodule NAME)
	if (NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${NAME}/CMakeLists.txt" )
        # Submodule hasn't been initialized yet, so call git submodule update --init on it
        message(STATUS "Initializing submodule: ${CMAKE_CURRENT_SOURCE_DIR}/${NAME}...")
        find_package(Git REQUIRED)
        execute_process(
            COMMAND ${GIT_EXECUTABLE} submodule update --init -- ${NAME} 
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            COMMAND_ERROR_IS_FATAL ANY
        )
	endif()
endfunction()
