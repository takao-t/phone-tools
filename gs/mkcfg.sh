#!/bin/sh
#
# Grandstream GXP-2135 プロビジョン用ファイル生成スクリプト
#


# テンプレートファイル
# 共通テンプレート
CTEMPLATE="./common_templ.xml"
# デバイス毎テンプレート
DTEMPLATE="./dev_templ.xml"

# デバイスリスト
LIST="./gs_phones.txt"

# デフォルト着信音(0,1,2,3)
RINGTONE="2"

# プロビジョンファイルのプレフィクスとサフィックス
# 通常は cfgXXXXXXXX.xml の型式
PREFIX="cfg"
SUFFIX="xml"

# プロビジョンサーバとパスの指定
PROVS="192.168.254.175/gs"

# 共通プロビジョンファイル生成
cat $CTEMPLATE |  sed s/##DISPNAME##/$DISPNAME/  | sed s/##MACADDR##/$MACADDR/ |  sed s^##PROVSERVER##^$PROVS^ | sed s/##RINGTONE##/$RINGTONE/ > $PREFIX.$SUFFIX

# 個別プロビジョンファイル生成
while read LINE
do
    if echo $LINE | grep '^#' > /dev/null 2>&1;
    then
        continue
    fi
    # echo $LINE
    MACADDR=`echo $LINE | cut -f1,1 -d',' | tr [:upper:] [:lower:]`
    UMACADDR=`echo $MACADDR | tr [:lower:] [:upper:]`
    DISPNAME=`echo $LINE | cut -f2,2 -d','`
    SIPSERVER=`echo $LINE | cut -f3,3 -d','`
    USERNAME=`echo $LINE | cut -f4,4 -d','`
    PASSWORD=`echo $LINE | cut -f5,5 -d','`
    TARGET=$MACADDR

    cat $DTEMPLATE | sed s/##SIPSERVER##/$SIPSERVER/  | sed s/##SIPUSERNAME##/$USERNAME/  | sed s/##SIPPASSWORD##/$PASSWORD/  | sed s/##DISPNAME##/$DISPNAME/  | sed s/##MACADDR##/$MACADDR/ | sed s/##UMACADDR##/$UMACADDR/ > $PREFIX$TARGET.$SUFFIX
    echo "$TARGET - done"
done < $LIST
