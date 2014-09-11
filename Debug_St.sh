#!/bin/sh

#  Debug_St.sh
#  Test_Local_Two
#
#  Created by admin on 14-8-12.
#  Copyright (c) 2014年 com.yongche. All rights reserved.

storyboardExt=".storyboard"
appStoryboardExt=".storyboardc"
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
echo "==========Merge====================="
# Merge baseStringsPath to localeStringsPath
awk  'NR == FNR && /^\/\*/ {x=$0; getline; a[x]=$0; next} /^\/\*/ {x=$0; print; getline; $0=a[x]?a[x]:$0; printf $0"\n\n"}' $oldLocaleStringsPath $baseStringsPath > $localeStringsPath
rm $oldLocaleStringsPath

fi
done
#remove baseString
rm $baseStringsPath

#debug
#if find $storyboardPath -prune -newer $ll -print | grep -q .; then
#echo "=================="
#fi
done
