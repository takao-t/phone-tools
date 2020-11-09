#!/bin/sh
#
# CSVからGS電話帳を生成
#

# 外線発信時のプレフィクスを設定のこと
PREFIX="0-"

# 1行目は設定項目
read FIRST

S1="accountindex"
S2=`echo $FIRST | cut -f2,2 -d','`
S3=`echo $FIRST | cut -f3,3 -d','`
S4=`echo $FIRST | cut -f4,4 -d','`
S5=`echo $FIRST | cut -f5,5 -d','`

echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<AddressBook>'

while read LINE
do
    F1="1"
    F2=`echo $LINE | cut -f2,2 -d','`
    F3=`echo $LINE | cut -f3,3 -d','`
    F4=`echo $LINE | cut -f4,4 -d','`
    F5=`echo $LINE | cut -f5,5 -d','`

    echo '<Contact>'
    echo "  <$S2>$F2</$S2>"
    echo "  <$S3>$F3</$S3>"
    echo "  <$S4>$F4</$S4>"
    echo "  <Phone>"
    echo "      <$S5>$PREFIX$F5</$S5>"
    echo "      <$S1>$F1</$S1>"
    echo "  </Phone>"
    echo '</Contact>'
done

echo '</AddressBook>'
