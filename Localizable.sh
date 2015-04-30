#!/bin/sh

#  Localizable.sh
#  Test_Local_Two on github
#  internationalization for xib or stroyboard on  project
#
#  Created by githhhh on 14-10-10.
#  Copyright (c) 2014年 . All rights reserved.

#default global parameter is storyboard
xibOrsbExt=".storyboard"
appXibOrsbExt=".storyboardc"  #compiled .storyboard is  .storyboardc


#Define a function
function localXibOrsbFun(){

#define local parameter
stringsExt=".strings"
newStringsExt=".strings.new"
oldStringsExt=".strings.old"
localeDirExt=".lproj"
baseLprojName="Base.lproj"


# Find storyboard or xib  file full path inside project folder
for xibOrsbPath in `find ${SRCROOT} -name "*$xibOrsbExt" -print`
do
#########################图片国际化##############################
#搜索指定字符串
imgName=$(cat $xibOrsbPath|grep -o  '<image name="\w*\.\{0,1\}\w*"'|awk -F'"' '{print$2}')
#用数组保持
array=("$imgName")
#########################图片国际化##############################


# Get storyboard or xib file name and folder
xibOrsbFile=$(basename "$xibOrsbPath")

#compiled .storyboard or .xib   to   storyboardc or nib .   .storyboardc and .nib is dir
file=$xibOrsbFile
xibOrsbFileName=${file%.*}
onappXibOrsbFileName=$xibOrsbFileName$appXibOrsbExt

#xibOrsbDir
xibOrsbDir=$(dirname "$xibOrsbPath")
#echo $xibOrsbDir
#echo $xibOrsbFile

# Get xibOrsbDir upLevel dirName  and dir
current_XibOrsb_LprojName=$(basename "$xibOrsbDir")
current_XibOrsb_LprojDir=$(dirname "$xibOrsbDir")

#limite on base.lproj
if [ "$current_XibOrsb_LprojName" != "$baseLprojName" ]; then
continue
fi

# Get Base strings file full path
baseStringsPath=$(echo "$xibOrsbPath" | sed "s/$xibOrsbExt/$stringsExt/")

# Get New Base strings file full path and strings file name
newBaseStringsPath=$(echo "$xibOrsbPath" | sed "s/$xibOrsbExt/$newStringsExt/")
stringsFile=$(basename "$baseStringsPath")

#convert .stroyboard or .xib  to .string
ibtool --export-strings-file $newBaseStringsPath $xibOrsbPath
iconv -f UTF-16 -t UTF-8 $newBaseStringsPath > $baseStringsPath
rm $newBaseStringsPath

#for  on base.lproj dir and find other language.lproj dir maxdepth 1
for localeStringsDir in `find ${current_XibOrsb_LprojDir}   -name "*$localeDirExt" -maxdepth 1  -print`
do

#localeStringsDir
otherLprojName=$(basename "$localeStringsDir")
echo $otherLprojName
localdirNameOnApp=${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/$otherLprojName

#########################图片国际化##############################
#遍历数组
filename=${array[n]}
for var in ${filename[@]};do
#判断是否包含扩展名如：.JPG .png
if [[ $var == *.* ]]
then
varString=$(echo $var|awk -F '.' '{print $1}')
else
varString=$var
fi

#搜索图片路径 支持pdf png jpg  -name "${varString}.jpg"  -name "${varString}*.png"
for imgPath in `find $(dirname "$localdirNameOnApp") -type f \( -name "${varString}.pdf" -o -name "${varString}*.png" -o -name "${varString}.JPG" -o -name "${varString}.jpg" \)   -print`
do
imgFileName=$(basename "$imgPath")
imgOnAppPath=$localdirNameOnApp/$imgFileName
echo  $imgPath
#判断是否存在
if [ ! -f "$imgOnAppPath" ];then
cp  $imgPath  $localdirNameOnApp
fi

done

done
#########################图片国际化##############################

# Skip Base.lproj folder
if [ "$otherLprojName" == "$baseLprojName" ];then
continue
fi

#on other lproj
localeStringsPath=$localeStringsDir/$stringsFile
localeXibOrsbPath=$localeStringsDir/$xibOrsbFile

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

#.string to .storyboard or .xib with ibtool on local.lproj
ibtool --strings-file $localeStringsPath --write $localeXibOrsbPath $xibOrsbPath

#(.stroyboard to  .storyboardc) or (.xib to .nib)     on local.lproj
appXibOrsbFile=$localeStringsDir/$onappXibOrsbFileName

#if your xib or storyboard use Auto Layout . target must be is 6.0 or after
ibtool --errors --warnings --notices --minimum-deployment-target 6.0  --output-format human-readable-text --compile  $appXibOrsbFile $localeXibOrsbPath

#rm localeXibOrsbPath
rm $localeXibOrsbPath

#cp .storyboardc or .nib to local.lproj on app
#Judge .lproj exists.
#判断.lproj 是否存在 。
if [ ! -x "$localdirNameOnApp" ]; then
mkdir "$localdirNameOnApp"
fi
cp -r  $appXibOrsbFile $localdirNameOnApp

#appXibOrsbFile is dir
rm -rf $appXibOrsbFile

done

#remove baseString
rm $baseStringsPath

done
}



#call function
localXibOrsbFun

#change global parameter to xib
xibOrsbExt=".xib"
appXibOrsbExt=".nib"

#call function
localXibOrsbFun

