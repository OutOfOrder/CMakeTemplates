if(APPLE)
    set(suffix "macosx")
elseif(WIN32)
    set(suffix "win32")
elseif(CMAKE_SYSTEM MATCHES "Linux")
    set(suffix "linux")
endif()

find_library(SDL2_LIBRARY
    NAMES SDL2
    PATHS "${CMAKE_CURRENT_LIST_DIR}/${suffix}/lib" "${CMAKE_CURRENT_LIST_DIR}/${suffix}"
    NO_DEFAULT_PATH
    NO_CMAKE_FIND_ROOT_PATH
)
find_library(SDL2_main_LIBRARY
    NAMES SDL2main
    PATHS "${CMAKE_CURRENT_LIST_DIR}/${suffix}/lib" "${CMAKE_CURRENT_LIST_DIR}/${suffix}"
    NO_DEFAULT_PATH
    NO_CMAKE_FIND_ROOT_PATH
)
find_path(SDL2_INCLUDE_DIR
    NAMES SDL.h
    PATHS "${CMAKE_CURRENT_LIST_DIR}/include"
    PATH_SUFFIXES SDL2
    NO_DEFAULT_PATH
    NO_CMAKE_FIND_ROOT_PATH
)
set(SDL2_INCLUDE_DIRS ${SDL2_INCLUDE_DIR})
set(SDL2_LIBRARIES ${SDL2_LIBRARY})
if(SDL2_main_LIBRARY)
    list(APPEND SDL2_LIBRARIES
        ${SDL2_main_LIBRARY}
    )
endif()

mark_as_advanced(SDL2_INCLUDE_DIR SDL2_LIBRARY SDL2_main_LIBRARY)

if(NOT TARGET SDL2 AND CMAKE_VERSION VERSION_GREATER 3.0.0)
    add_library(SDL2 INTERFACE)
    target_link_libraries(SDL2 INTERFACE ${SDL2_LIBRARIES})
    target_include_directories(SDL2 INTERFACE ${SDL2_INCLUDE_DIRS})
endif()
