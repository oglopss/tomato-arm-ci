#!/usr/bin/env bash

export BROADCOM_SDK=src-rt-6.x.4708
export GH_TOKEN=NOTSET

if [ -z $1 ]; then
  BUILDS="r64z,1 n18z,2 r7000z,3 r6400z,5 ws880z,11 wzr1750z,12 ea6700z,13"
else
  BUILDS=$1,1
fi

idx=1

for i in $BUILDS; do
  # echo building $i

  KEY=${i%,*};
  VAL=${i#*,};
  echo $KEY" --- fake job number "$VAL;

  export TT_BUILD=$KEY
  export TRAVIS_JOB_NUMBER=$VAL

  cd ~/tomato-arm
  git clean -xfd
  git checkout .

  echo current dir: `pwd`

  . ~/tomato-arm-ci/.travis.sh

  # pre_build_prep

  cd ~/tomato-arm/release/$BROADCOM_SDK

  build_tomato

  cd ~/tomato-arm/release/$BROADCOM_SDK

  # only upload to my repo if manual argument is passed
  if [ "GH_TOKEN" != "NOTSET" ]; then
    . ~/tomato-arm-ci/update-gh-pages.sh manual
  fi

  # break

done





