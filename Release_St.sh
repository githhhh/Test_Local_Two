#!/bin/sh

#  Script.sh
#  Test_Local_Two
#
#  Created by admin on 14-8-12.
#  Copyright (c) 2014年 com.yongche. All rights reserved.
storyboardExt=".storyboard"
stringsExt=".strings"
newStringsExt=".strings.new"
oldStringsExt=".strings.old"
localeDirExt=".lproj"

# Find storyboard file full path inside project folder
for storyboardPath in `find ${SRCROOT} -name "*$storyboardExt" -print`
do
# Get Base strings file full path
baseStringsPath=$(echo "$storyboardPath" | sed "s/$storyboardExt/$stringsExt/")

# Create strings file only when storyboard file newer
#if find $storyboardPath -prune -newer $baseStringsPath -print | grep -q .; then
# Get storyboard file name and folder
storyboardFile=$(basename "$storyboardPath")
storyboardDir=$(dirname "$storyboardPath")

# Get New Base strings file full path and strings file name
newBaseStringsPath=$(echo "$storyboardPath" | sed "s/$storyboardExt/$newStringsExt/")
stringsFile=$(basename "$baseStringsPath")
ibtool --export-strings-file $newBaseStringsPath $storyboardPath
iconv -f UTF-16 -t UTF-8 $newBaseStringsPath > $baseStringsPath
rm $newBaseStringsPath

# Get all locale strings folder
for localeStringsDir in `find ${SRCROOT} -name "*$localeDirExt" -print`
do
# Skip Base strings folder
if [ $localeStringsDir != $storyboardDir ]; then
localeStringsPath=$localeStringsDir/$stringsFile

# Just copy base strings file on first time
if [ ! -e $localeStringsPath ]; then
cp $baseStringsPath $localeStringsPath
else
oldLocaleStringsPath=$(echo "$localeStringsPath" | sed "s/$stringsExt/$oldStringsExt/")
cp $localeStringsPath $oldLocaleStringsPath

# Merge baseStringsPath to localeStringsPath
awk 'NR == FNR && /^\/\*/ {x=$0; getline; a[x]=$0; next} /^\/\*/ {x=$0; print; getline; $0=a[x]?a[x]:$0; printf $0"\n\n"}' $oldLocaleStringsPath $baseStringsPath > $localeStringsPath

rm $oldLocaleStringsPath
fi
fi
done
#else
#echo "$storyboardPath file not modified."
#fi
done