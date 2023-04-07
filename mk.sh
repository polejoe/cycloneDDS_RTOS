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


list="helloworld cdds_rgb throughput listtopics"


mk_app()
{

  for dd in $list; do

    cd ${ROOT}/examples/$dd || {
        echo " app $dd not exist!"
        continue
    }
    mkdir -p build
    cd build
    rm -f CMakeCache.txt

    cmake ../  -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Debug  | tee $logf

    make clean 2>&1 >/dev/null
    cmake --build . | tee -a $logf

    echo "@@@@@@@@@@@@@@ build APP $dd done "
  done
    #cd -
}


if [ "$1" = "lib" ]; then
    mk_lib
elif [ "$1" = "all" ]; then
    mk_lib
    mk_app
else
    mk_app
fi


