#!/bin/bash

## Replace all wdt to pdt
[ -n "$WDT_DIR" ] || WDT_DIR=src/wdt

(cd $WDT_DIR; sed -i 's/wdt/pdt/g; s/wdT/pdT/g; s/wDt/pDt/g; s/wDT/pDT/g; s/Wdt/Pdt/g; s/WdT/PdT/g; s/WDt/PDt/g; s/WDT/PDT/g' `grep wdt -irl .`)

pushd .
cd $WDT_DIR
declare -A nameConv 
nameConv[wdt]="pdt"
nameConv[wdT]="pdT"
nameConv[wDt]="pDt"
nameConv[wDT]="pDT"
nameConv[Wdt]="Pdt"
nameConv[WdT]="PdT"
nameConv[WDt]="PDt"
nameConv[WDT]="PDT"

keywords="wdt wdT wDt wDT Wdt WdT WDt WDT"
for keyword in $keywords; do
  files=`find . -name "*${keyword}*"`
  for file in $files; do
    newpath=`echo $file | sed "s/$keyword/${nameConv[$keyword]}/g"`
    mv $file $newpath 
  done
done
popd

(cd $WDT_DIR/..; mv wdt pdt)
## done of replacing

