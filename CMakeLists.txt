cmake_minimum_required(VERSION 2.8.11)
Project(GameName)

### pull in boilerplate cmake
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(BoilerPlate)

# this sets the paths that cmake will use to locate libs (via the FindXXX.cmake or XXConfig.cmake scripts)
LIST(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_SOURCE_DIR}/prebuilt)

include(UtilityFunctions)

### Find Libraries
find_package(OpenGL)
find_package(Threads)
find_package(OpenAL)
find_package(SDL2)
option(USE_STEAM "Enable Steam Support" OFF)
if(USE_STEAM)
    find_package(Steam)
endif()

## Setup libs
CreateLibrary(fun
DIRS
    ext/fun/src
INCLUDES
    PRIVATE
        ext/fun/src
    PUBLIC
        ext/fun/include
DEFINES
    PRIVATE
        ENABLE_FOOBAR
    PUBLIC
        FUN_STATIC
FLAGS
    -Wall
PROPERTIES
    FOLDER Libraries
)

CreateLibrary(GameLibrary
DIRS
    engine/src
INCLUDES
    PUBLIC
        engine/src
    PRIVATE
        ${SDL2_INCLUDE_DIRS}
        ${OPENAL_INCLUDE_DIRS}
        $<$<BOOL:${USE_STEAM}>:${STEAM_INCLUDE_DIRS}>
DEFINES
    PUBLIC
        $<$<BOOL:${LINUX}>:PLATFORM_LINUX>
        $<$<BOOL:${APPLE}>:PLATFORM_OSX>
        $<$<BOOL:${WIN32}>:PLATFORM_WIN>
        $<$<CONFIG:Debug>:BUILD_DEBUG>
        $<$<NOT:$<CONFIG:Debug>>:BUILD_FINAL>
        $<$<BOOL:${USE_STEAM}>:WITH_STEAM>
LINK
    fun # this automatically pulls in the fun specific header directory
    ${CMAKE_THREAD_LIBS_INIT}
    ${SDL2_LIBRARIES}
    ${OPENGL_gl_LIBRARY}
    ${OPENAL_LIBRARIES}
    $<$<BOOL:${USE_STEAM}>:${STEAM_LIBRARIES}>
PROPERTIES
    FOLDER Libraries
)

CreateProgram(${PROJECT_NAME}
DIRS
    game/src
INCLUDE
    game/src
LINK
    GameLibrary  # this will automatically pull in all required libs, includes, and defines that GameLibrary requires
PROPERTIES
    FOLDER Executables
)

## this auto copies the needed libraries / frameworks over
CopyDependentLibs(${PROJECT_NAME})

