#!/bin/sh

#  Debug_St.sh
#  Test_Local_Two
#
#  Created by admin on 14-8-12.
#  Copyright (c) 2014年 com.yongche. All rights reserved.

#define global parameter
storyboardExt=".storyboard"
appStoryboardExt=".storyboardc"


#function localizable
function localizableFun(){

#define local parameter
stringsExt=".strings"
newStringsExt=".strings.new"
oldStringsExt=".strings.old"
localeDirExt=".lproj"
baseLprojName="Base.lproj"


# Find storyboard file full path inside project folder
for storyboardPath in `find ${SRCROOT} -name "*$storyboardExt" -print`
do
# Get storyboard file name and folder
storyboardFile=$(basename "$storyboardPath")

#compiled .storyboard  编译后的storyboard is storyboardc    .storyboardc is dir
file=$storyboardFile
storyboardfileName=${file%.*}
onappStoryboardFileName=$storyboardfileName$appStoryboardExt

#storyboardDir
storyboardDir=$(dirname "$storyboardPath")

# Get storyboardDir upLevel dirName  and dir
currentSbLprojName=$(basename "$storyboardDir")
currentSbLprojDir=$(dirname "$storyboardDir")

#limite on base.lproj
if [ "$currentSbLprojName" != "$baseLprojName" ]; then
continue
fi

# Get Base strings file full path
baseStringsPath=$(echo "$storyboardPath" | sed "s/$storyboardExt/$stringsExt/")

# Get New Base strings file full path and strings file name
newBaseStringsPath=$(echo "$storyboardPath" | sed "s/$storyboardExt/$newStringsExt/")
stringsFile=$(basename "$baseStringsPath")

#convert .stroyboard to .string
ibtool --export-strings-file $newBaseStringsPath $storyboardPath
iconv -f UTF-16 -t UTF-8 $newBaseStringsPath > $baseStringsPath
rm $newBaseStringsPath

#for  on base.lproj dir and find other language.lproj dir maxdepth 1
for localeStringsDir in `find ${currentSbLprojDir}   -name "*$localeDirExt" -maxdepth 1  -print`
do

#localeStringsDir
otherLprojName=$(basename "$localeStringsDir")

# Skip Base.lproj folder
if [ "$otherLprojName" == "$baseLprojName" ];then
continue
fi

#on other lproj
localeStringsPath=$localeStringsDir/$stringsFile
localeStoryBoardPath=$localeStringsDir/$storyboardFile

# Just copy base strings file on  not file  or file is empty  else merge
if [ ! -e $localeStringsPath ]||[ ! -s $localeStringsPath ]; then
cp $baseStringsPath $localeStringsPath
else
oldLocaleStringsPath=$(echo "$localeStringsPath" | sed "s/$stringsExt/$oldStringsExt/")
cp $localeStringsPath $oldLocaleStringsPath

# Merge baseStringsPath to localeStringsPath
awk  'NR == FNR && /^\/\*/ {x=$0; getline; a[x]=$0; next} /^\/\*/ {x=$0; print; getline; $0=a[x]?a[x]:$0; printf $0"\n\n"}' $oldLocaleStringsPath $baseStringsPath > $localeStringsPath
rm $oldLocaleStringsPath
fi



#.string to .storyboard with ibtool on local.lproj
ibtool --strings-file $localeStringsPath --write $localeStoryBoardPath $storyboardPath

#.stroyboard to  .storyboardc on local.lproj
appStoryboardFile=$localeStringsDir/$onappStoryboardFileName
ibtool --errors --warnings --notices --minimum-deployment-target 6.0  --output-format human-readable-text --compile  $appStoryboardFile $localeStoryBoardPath

#rm localeStoryBoardPath
rm $localeStoryBoardPath

#cp .storyboardc to local.lproj on app
localdirNameOnApp=${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/$otherLprojName

#判断.lproj 是否存在 ,因为此脚本运行在 拷贝资源文件之前。
if [ ! -x "$localdirNameOnApp" ]; then
mkdir "$localdirNameOnApp"
fi
cp -r  $appStoryboardFile $localdirNameOnApp

#appStoryboardFile is dir
rm -rf $appStoryboardFile


done


#remove baseString
rm $baseStringsPath

#debug
#if find $storyboardPath -prune -newer $ll -print | grep -q .; then
#echo "==========debug========"
#fi
done

}

#call fun
localizableFun

#change arg
storyboardExt=".xib"
appStoryboardExt=".nib"

#call fun
localizableFun

