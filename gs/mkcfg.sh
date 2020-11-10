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

# デフォルトゲートウェイ
DEFGW="192.168.254.253"
# サブネットマスク
NMASK="255.255.255.0"
# DNSサーバ
DNS="8.8.8.8"

# デフォルト着信音(0,1,2,3)
RINGTONE="2"

# プロビジョンファイルのプレフィクスとサフィックス
# 通常は cfgXXXXXXXX.xml の型式
PREFIX="cfg"
SUFFIX="xml"

# プロビジョンサーバとパスの指定
PROVS="192.168.254.175/gs"

# 各オクテットに分解
GO1=`echo $DEFGW | cut -f1,1 -d'.'`
GO2=`echo $DEFGW | cut -f2,2 -d'.'`
GO3=`echo $DEFGW | cut -f3,3 -d'.'`
GO4=`echo $DEFGW | cut -f4,4 -d'.'`
MO1=`echo $NMASK | cut -f1,1 -d'.'`
MO2=`echo $NMASK | cut -f2,2 -d'.'`
MO3=`echo $NMASK | cut -f3,3 -d'.'`
MO4=`echo $NMASK | cut -f4,4 -d'.'`
DO1=`echo $DNS | cut -f1,1 -d'.'`
DO2=`echo $DNS | cut -f2,2 -d'.'`
DO3=`echo $DNS | cut -f3,3 -d'.'`
DO4=`echo $DNS | cut -f4,4 -d'.'`

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
    DEVIP=`echo $LINE | cut -f6,6 -d','`
    TARGET=$MACADDR

    if [ $DEVIP = "dhcp" ]
    then
        NETINFO="<P8>0</P8>" 
    else
        IO1=`echo $DEVIP | cut -f1,1 -d'.'`
        IO2=`echo $DEVIP | cut -f2,2 -d'.'`
        IO3=`echo $DEVIP | cut -f3,3 -d'.'`
        IO4=`echo $DEVIP | cut -f4,4 -d'.'`
        IPADR="<P9>$IO1</P9><P10>$IO2</P10><P11>$IO3</P11><P12>$IO4</P12>"
        SMASK="<P13>$MO1</P13><P14>$MO2</P14><P15>$MO3</P15><P16>$MO4</P16>"
        GWADDR="<P17>$GO1</P17><P18>$GO2</P18><P19>$GO3</P19><P20>$GO4</P20>"
        DNSADDR="<P21>$DO1</P21><P22>$DO2</P22><P23>$DO3</P23><P24>$DO4</P24>"
        NETINFO="<P8>1</P8>$IPADR$SMASK$GWADDR$DNSADDR"
    fi

    cat $DTEMPLATE | sed s/##SIPSERVER##/$SIPSERVER/  | sed s/##SIPUSERNAME##/$USERNAME/  | sed s/##SIPPASSWORD##/$PASSWORD/  | sed s/##DISPNAME##/$DISPNAME/  | sed s/##MACADDR##/$MACADDR/ | sed s/##UMACADDR##/$UMACADDR/ | sed -e "s@##NETINFO##@$NETINFO@" > $PREFIX$TARGET.$SUFFIX
    echo "$TARGET - done"
done < $LIST
