# GnuPG-Windows
A fork of GnuPG https://gnupg.org/ with the necessary modules along with Windows specific patches.

## Requirements
* Git
* CMake
* Clang compiler for Windows (only), GCC or Clang on Linux
* grep and gawk (On Windows it should come with Git Bash)

>:NOTE: MSVC isn't the compiler for job see the msvc directory for more information.

## Instructions
On Windows
```
git clone --recurse-submodules https://github.com/SibiSiddharthan/gnupg-windows.git
cd gnupg-windows
mkdir build
cd build
set CC=clang # Make sure you use clang as your compiler
cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release
ninja
ctest        # run the tests
```
On Linux
```
git clone --recurse-submodules https://github.com/SibiSiddharthan/gnupg-windows.git
cd gnupg-windows
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
ctest
```

## License
Only the CMake build scripts are licensed under the MIT License.
The binaries produced will be licensed under LGPL or GPL. See the respective modules for information.
