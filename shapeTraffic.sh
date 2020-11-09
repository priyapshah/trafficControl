#!/bin/bash
TC = /sbin/tc
IFACE = enp0s3
LIMIT = 100mbps

DST_CDIR = 10.0.2.15/32
DST_CDIR2 = 1.1.1.1/32

real="$TC filter add dev $IF protocol ip parent 1:0 prio 1 u32"
dummy="$TC filter add dev $IF protocol ip parent 1:0 prio 1 u32"

makeQdiscTree () {
    # root
    $TC qdisc add dev $IFACE root handle 1:0 htb 

    # child 1 - real
    $TC class add dev $IFACE parent 1:0 classid 1:1 htb rate $LIMIT

    # child 2 - dummy
    $TC class add dev $IFACE parent 1:0 classid 1:2 htb rate $LIMIT
    
    # filter
    $U3 match ip dst $DST_CDIR flowid 1:1
    $U3 match ip dst $DST_CDIR2 flowid 1:2
}

erasePrev () {
    $TC qdisc del dev $IFACE root
}

erasePrev
makeQdiscTree
