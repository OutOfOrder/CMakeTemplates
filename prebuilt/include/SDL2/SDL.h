#ifndef SDL_H
#define SDL_H

#if defined (_WIN32) 
  #if defined(SDL2_EXPORTS)
    #define  MYLIB_EXPORT __declspec(dllexport)
  #else
    #define  MYLIB_EXPORT __declspec(dllimport)
  #endif /* MyLibrary_EXPORTS */
#else /* defined (_WIN32) */
 #define MYLIB_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

MYLIB_EXPORT int SDL_Init(int flags);
MYLIB_EXPORT int SDL_Quit();

#ifdef __cplusplus
}
#endif

#endif