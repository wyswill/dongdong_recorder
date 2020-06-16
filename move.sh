#!/bin/bash
buildPath="$PWD/build/app/outputs/apk"
realtivePath=$PWD
if [ ! -d "$buildPath" ]; then
  echo "在build文件夹中的apk文件夹未找到"
  if [ -d "$realtivePath/apk" ]; then
    echo "在根目录中找到了apk文件夹，请检查是否可用"
    exit 0
  fi
else
  echo "apk文件夹find"
fi
mv "$buildPath" "$realtivePath"
