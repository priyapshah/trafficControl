#!/bin/bash
TC=/sbin/tc
IFACE=ens33
LIMIT=500kbit

DST_CDIR=172.16.139.2/32
DST_CDIR2=1.1.1.1/32

echo "Working"

makeQdiscTree () {
    # root
    $TC qdisc add dev $IFACE root handle 1: htb default 3

    # parent
    $TC class add dev $IFACE parent 1: classid 1:1 htb rate $LIMIT ceil $LIMIT

    # child 1
    $TC class add dev $IFACE parent 1:1 classid 1:3 htb rate $LIMIT ceil $LIMIT prio 0

    # child 2
    $TC class add dev $IFACE parent 1:1 classid 1:2 htb rate 10kbps ceil $LIMIT prio 5
    
    # filter
    $TC filter add dev $IFACE protocol ip parent 1:0 prio 1 u32 match ip dst $DST_CDIR2 flowid 1:2
    
}

erasePrev () {
    $TC qdisc del dev $IFACE root
}

erasePrev
makeQdiscTree

echo "Done"