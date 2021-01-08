#!/bin/bash
TC=/sbin/tc
IF=ens33
LIMIT=50kbit

DST=172.16.139.2/32

makeQdiscTree () {
    echo "Shaping Starting"

    $TC qdisc add dev $IF root handle 1:0 htb default 1

    $TC class add dev $IF parent 1:0 classid 1:1 htb rate $LIMIT ceil $LIMIT
    
    $TC filter add dev $IF protocol ip parent 1:0 prio 1 u32 match ip dst $DST flowid 1:1
    
    echo "Done"
}

erasePrev () {
    $TC qdisc del dev $IF root
}

erasePrev
makeQdiscTree