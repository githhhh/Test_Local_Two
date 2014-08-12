#!/bin/sh

#  Debug_St.sh
#  Test_Local_Two
#
#  Created by admin on 14-8-12.
#  Copyright (c) 2014年 com.yongche. All rights reserved.

storyboardExt=".storyboard"
stringsExt=".strings"
newStringsExt=".strings.new"
oldStringsExt=".strings.old"
localeDirExt=".lproj"
baseLprojName="Base.lproj"


# Find storyboard file full path inside project folder   current single sb
for storyboardPath in `find ${SRCROOT} -name "*$storyboardExt" -print`
do
# Get Base strings file full path
baseStringsPath=$(echo "$storyboardPath" | sed "s/$storyboardExt/$stringsExt/")
# Get storyboard file name and folder
storyboardFile=$(basename "$storyboardPath")
storyboardDir=$(dirname "$storyboardPath")

# Get New Base strings file full path and strings file name
newBaseStringsPath=$(echo "$storyboardPath" | sed "s/$storyboardExt/$newStringsExt/")
stringsFile=$(basename "$baseStringsPath")
#重写转换.string 文件
ibtool --export-strings-file $newBaseStringsPath $storyboardPath
iconv -f UTF-16 -t UTF-8 $newBaseStringsPath > $baseStringsPath

rm $newBaseStringsPath

# Get all locale strings folder
for localeStringsDir in `find ${SRCROOT} -name "*$localeDirExt" -print`
do
echo $localeStringsPath
temp=$(basename "$localeStringsDir")

# Skip Base.lproj folder
if [ "$temp" != "$baseLprojName" ];then
localeStringsPath=$localeStringsDir/$stringsFile


# Just copy base strings file on first time
if [ ! -e $localeStringsPath ]; then
cp $baseStringsPath $localeStringsPath
else
oldLocaleStringsPath=$(echo "$localeStringsPath" | sed "s/$stringsExt/$oldStringsExt/")
echo $oldLocaleStringsPath
cp $localeStringsPath $oldLocaleStringsPath

# Merge baseStringsPath to localeStringsPath
awk  'NR == FNR && /^\/\*/ {x=$0; getline; a[x]=$0; next} /^\/\*/ {x=$0; print; getline; $0=a[x]?a[x]:$0; printf $0"\n\n"}' $oldLocaleStringsPath $baseStringsPath > $localeStringsPath

rm $oldLocaleStringsPath
fi

fi

done

done