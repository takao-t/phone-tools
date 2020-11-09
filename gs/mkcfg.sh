#!/bin/sh
#
# Grandstream GXP-2135 プロビジョン用ファイル生成スクリプト
#
# どのパラメータがGSのPコードに対応するかはテンプレートを参照のこと
#

# テンプレートファイル
TEMPLATE="./gxp2135_templ.xml"

# デバイスリスト
LIST="./gs_phones.txt"

# デフォルト着信音(0,1,2,3)
RINGTONE="2"

# プロビジョンファイルのプレフィクスとサフィックス
# 通常は cfgXXXXXXXX.xml の型式
PREFIX="cfg"
SUFFIX="xml"

# プロビジョンサーバとパスの指定
# 電話帳ダウンロードも同じパスを使用する
PROVS="192.168.1.1/gs"

while read LINE
do
    if echo $LINE | grep '^#' > /dev/null 2>&1;
    then
        continue
    fi
    # echo $LINE
    MACADDR=`echo $LINE | cut -f1,1 -d','`
    DISPNAME=`echo $LINE | cut -f2,2 -d','`
    SIPSERVER=`echo $LINE | cut -f3,3 -d','`
    USERNAME=`echo $LINE | cut -f4,4 -d','`
    PASSWORD=`echo $LINE | cut -f5,5 -d','`
    TARGET=`echo $MACADDR | tr [A-Z] [a-z]`

    cat $TEMPLATE | sed s/##SIPSERVER##/$SIPSERVER/  | sed s/##SIPUSERNAME##/$USERNAME/  | sed s/##SIPPASSWORD##/$PASSWORD/  | sed s/##DISPNAME##/$DISPNAME/  | sed s/##MACADDR##/$MACADDR/ | sed s/##RINGTONE##/$RINGTONE/ | sed s^##PROVSERVER##^$PROVS^ > $PREFIX$TARGET.$SUFFIX
    echo "$TARGET - done"
done < $LIST
