#include "engine.h"

#ifdef WIN32
#include <Windows.h>
int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPrev, LPSTR szCmdLine, int sw)
#else
int main(int argc, char* argv[])
#endif
{
    initGame();

    return 0;
}