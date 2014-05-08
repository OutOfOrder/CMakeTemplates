cmake_minimum_required(VERSION 2.8.11)
Project(GameName)

### pull in boilerplate cmake
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(BoilerPlate)

# this will look for ${source_dir}/prebuilt/linux on linux.
find_path(PREBUILT_PLATFORM_ROOTS .
    PATHS ${CMAKE_CURRENT_SOURCE_DIR}/prebuilt/${PLATFORM_PREFIX}
    NO_DEFAULT_PATH
)
mark_as_advanced(
    PREBUILT_PLATFORM_ROOTS
)

include(UtilityFunctions)

### Find Libraries
find_package(OpenGL)
find_package(Threads)
if(LINUX)
    FindPrebuiltLibrary(OPENAL_LIBRARY openal)
else()
    find_package(OpenAL)
endif()
FindPrebuiltLibrary(SDL2_LIBRARY SDL2)
option(USE_STEAM "Enable Steam Support" OFF)
if(USE_STEAM)
    FindPrebuiltLibrary(STEAM_LIBRARY steam_api)
endif()

### Setup Compler definitions
set(GAME_DEFINITIONS
    PUBLIC $<$<BOOL:${LINUX}:PLATFORM_LINUX>
    PUBLIC $<$<BOOL:${APPLE}:PLATFORM_OSX>
    PUBLIC $<$<BOOL:${WIN32}:PLATFORM_WIN>
    PUBLIC $<$<CONFIG:Debug>:BUILD_DEBUG>
    PUBLIC $<$<NOT:$<CONFIG:Debug>>:BUILD_FINAL>
    PUBLIC $<$<BOOL:${USE_STEAM}:WITH_STEAM>
)

set(GAME_INCLUDES
    PUBLIC engine/src
    PUBLIC prebuilt/include
)

## Setup libs
CreateLibrary(fun
    ext/fun/src
INCLUDES
    PRIVATE ext/fun/src
    PUBLIC ext/fun/include
DEFINES
    PRIVATE ENABLE_FOOBAR
    PUBLIC FUN_STATIC
FLAGS
    -Wall
)

CreateLibrary(GameLibrary
    engine/src
INCLUDE
    ${GAME_INCLUDES}
FLAGS
    ${GAME_DEFINITIONS}
LINK
    fun # this automatically pulls in the fun specific header directory
    ${CMAKE_THREADS_LIBS_INIT}
    ${SDL2_LIBRARY}
    ${STEAM_LIBRARY}
)

CreateProgram(${PROJECT_NAME}
    game/src
INCLUDE
    game/src
LINK
    GameLibrary  # this will automatically pull in all required libs, includes, and defines that GameLibrary requires
)

if(APPLE)
    set(GAME_COPY_FRAMEWORKS ${SDL2_LIBRARY})
    PostBuildMacBundle(${target} "${GAME_COPY_FRAMEWORKS}" "${STEAM_LIBRARY}")
    PostBuildCopyMacResourceDir(${target} "${CMAKE_CURRENT_SOURCE_DIR}/game/data")
endif()

