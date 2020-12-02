#!/bin/bash
TC=/sbin/tc
IFACE=ens33
LIMIT=100mbps

DST_CDIR=127.0.0.1/32
DST_CDIR2=1.0.0.1/32

echo "Working"

makeQdiscTree () {
    # root
    $TC qdisc add dev $IFACE root handle 1: htb default 30

    # parent
    $TC class add dev $IFACE parent 1:0 classid 1:1 htb rate $LIMIT

    # child 1 - real
    $TC class add dev $IFACE parent 1:1 classid 1:2 htb ceil $LIMIT rate 1mbps

    # child 2 - dummy
    $TC class add dev $IFACE parent 1:1 classid 1:3 htb rate $LIMIT
    
    # filter
    $TC filter add dev $IFACE protocol ip parent 1:0 prio 1 u32 match ip dst $DST_CDIR flowid 1:2
    $TC filter add dev $IFACE protocol ip parent 1:0 prio 1 u32 match ip dst $DST_CDIR2 flowid 1:3
    
}

erasePrev () {
    $TC qdisc del dev $IFACE root
}

erasePrev
makeQdiscTree

echo "Done"

#iperf3