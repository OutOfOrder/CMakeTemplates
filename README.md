# CMake Templates
These are simple cmake base templates I've built up over the years of porting games to Mac OS X and Linux.

I've included "dummy source code" purely to show directory layouts and to show that the cmake magic works.

## FORCE32 flag
To ease development of 32bit applications on a 64bit host system (such as on Linux or Mac OS X) I've added a FORCE32 boolean option.. Simply setting it to ON when generating your project will force the library searching and compiler options to find/build 32bit executables.

## Prebuilt libraries

Often when developing games or porting games using a prebuilt library and including in the SCM tree is preferred as it simplifies getting the build system running across multiple systems and easier to manage updates.  There is a simple "FindPrebuiltLibrary" function to facilitate this searching with a shared prebuilt directory (see UtilityFunctions.cmake).

## Using CMake 2.8.11's PUBLIC/PRIVATE/INTERFACE library magic

CMake 2.8.11 added the ability to set target includes and compile options in a more useful manner. This allows other libraries/executables that depend on them to automatically pull in the needed flags/include directories without needing to fuss with global variables.   This is extremely useful when you split things up into multiple CMakeLists.txt files (e.g. a shared engine and multiple games that use it).  The example here makes use of the PRIVATE to note an include directory in libfun that is used by libfun itself and PUBLIC a different path that is to be used by libfun and anything that users libfun.

CMake also has what are called generator expressions, these are seen being used in the GAME_DEFINITIONS variable which is used on the GameLibrary target.  These very useful having CMake generate IDE projects such as Visual Studio and XCode, and they still work for simple systems like make, or ninja.
