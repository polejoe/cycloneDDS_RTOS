#!/bin/sh

logf=xx.log
install_dir=/usr/local

ROOT="$PWD"


mk_lib()
{
    cd ${ROOT}
    mkdir -p build
    cd build
    #rm -f CMakeCache.txt
    cmake ../ -DENABLE_SHM=NO -DBUILD_DDSPERF=NO \
                -DENABLE_IPV6=NO -DENABLE_SOURCE_SPECIFIC_MULTICAST=NO \
                -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Debug \
                -DCMAKE_INSTALL_PREFIX=$install_dir | tee $logf

    make clean 2>&1 >/dev/null
    cmake --build . | tee -a $logf

    sudo cmake --build . --target install | tee -a $logf

    echo "@@@@@@@@@@@@@@ build dds lib done, install to $install_dir"
    cd -
}

mk_app()
{
    cd ${ROOT}/examples/helloworld
    mkdir -p build
    cd build
    rm -f CMakeCache.txt

    cmake ../  -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Debug  | tee $logf

    make clean 2>&1 >/dev/null
    cmake --build . | tee -a $logf

    echo "@@@@@@@@@@@@@@ build helloworld done, run in $PWD "
    cd -
}


if [ "$1" = "lib" ]; then
    mk_lib
elif [ "$1" = "app" ]; then
    mk_app
else
    mk_lib
    mk_app
fi


