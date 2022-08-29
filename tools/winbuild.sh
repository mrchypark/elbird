## set cmake
## https://github.com/r-windows/rtools-packages#extra-build-utilities-ie-autotools
##

pacman -Syuu
pacman -S cmake
export PATH=/x86_64-w64-mingw32.static.posix/bin/:$PATH


git clone -b v0.11.2 --depth 1 https://github.com/bab2min/Kiwi
cd Kiwi

# cp -r include ../kiwi-build/

git rm third_party/mimalloc
git rm third_party/googletest
git rm third_party/cpuinfo
git submodule update --init --recursive
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DKIWI_BUILD_TEST=OFF -DKIWI_USE_CPUINFO=OFF -DKIWI_USE_MIMALLOC=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON ..

cmake -DCMAKE_BUILD_TYPE=Release -DKIWI_BUILD_TEST=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON ..
make kiwi_static
cp libkiwi_static.a ../../rwinlib-elbird/lib/i386/libkiwi.a
cp libkiwi_static.a ../../rwinlib-elbird/lib/x64/libkiwi.a
cp libkiwi_static.a ../../rwinlib-elbird/lib/x64-ucrt/libkiwi.a
cd ..
cp -r include/ ../rwinlib-elbird/



