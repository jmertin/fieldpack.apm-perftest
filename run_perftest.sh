#!/bin/bash
#
# Author: $Author: jmertin $
# Locked by: $Locker:  $
#
# This script will gather all information required for troubleshooting Networking issues
# with the TIM software

# I want it to be verbose.
VERBOSE=true

##########################################################################
# Nothing to be changed below this point !
##########################################################################

# Programm Version
VER="$Revision: 1.11 $"

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

# Get Program-Name, shortened Version.
PROGNAME="`basename $0 .sh`"

# Execution PID.
PROG_PID=$$

# Directory we work in.
BASEDIR=`pwd`

# Build Date in reverse - Prefix to builds
DATE=`date +"%Y%m%d"`

# Lockfile
LockFile="${BASEDIR}/${PROGNAME}..LOCK"

# Define the Hostname
HOSTName=`hostname -s`

# IP / Not working anymore.
IPAdd=`ifconfig | grep "inet addr:" | head -1 | awk '{ print $2}' | sed -e 's/addr\://g'`

# Logfile - all info will go in there.
LogFile="${BASEDIR}/${DATE}_${PROGNAME}_${HOSTName}_${IPAdd}.log"

SHAREMOD="${BASEDIR}/share/apm-share.mod"

if [ -f $SHAREMOD ]
then
    . $SHAREMOD
else
    echo "*** ERROR: Unable to load shared functions. Abort."
    exit
fi

##########################################################################
# Actual script start
##########################################################################

# Prevent double execution
Lock $LockFile 1


# Create Title
title "LOG Collector Interactive UI"

# Date + Time
LDATE=`date +"%F @ %T"`

# Catch user-name
USER=`whoami`


MSG="Creating logfile $LogFile"
echo -n > $LogFile
errlvl=$?
errors

# Set a title for the script
title "Disk performance IOPS test"

# Log program version.
MSG="$LDATE `whoami`@`hostname` - ${PROGNAME}.sh v$VER (apm-scripts ${RELEASE}-b${BUILD})"
log $MSG | tee -a $LogFile

if [ "$USER" != "root" ]
then

    MSG="This script requires root access, as regular users could be\n\tsubject to limitations applied by the OS"
    errlvl=1
    errors
fi

# Checking for the FIO binary
FIO=$( which fio 2>/dev/null )

if ! [ -x "$(command -v ${FIO})" ]
   then
    MSG="fio binary not found in path. Please install or adapt PATH variable"
    errlvl=1
    errors
fi

# Checking for the IOPing binary
IOP=$( which ioping 2>/dev/null )

if ! [ -x "$(command -v ${IOP})" ]
then       
    MSG="ioping binary not found in path. Please install or adapt PATH variable"
    errlvl=1
    errors  
fi

echo "The test directory needs to be situated on the disk/partition"
echo "that is to be tested. It will be created if non-existent and"
echo "its content and itself removed after the test."
echo -n "Please specific the test-directory [./perftest]: "
read TESTDIR

DIR=${TESTDIR:-perftest}

if [ ! -d $DIR ]
then
    MSG="Creating direcory $TESTDIR failed"
    mkdir -p $DIR
    errlvl=$?
    errors
fi

echo
entry "Running Kernel: uname -a"
uname -a | tee -a $LogFile

echo
entry "uptime"
uptime  | tee -a $LogFile

echo
entry "OS Information"
apmsysinfo | tee -a $LogFile

echo
entry "Memory Usage: free in MBytes"
free -m | tee -a $LogFile
echo -n "% Percent used RAM: "  | tee -a  $LogFile
free | grep Mem: | awk 'FNR == 1 {print $3/($3+$4)*100}'  | tee -a  $LogFile

echo -n "% Percent free RAM: "  | tee -a  $LogFile
free | grep Mem: | awk 'FNR == 1 {print $4/($3+$4)*100}'  | tee -a  $LogFile

echo
entry "Processes using SWAP (If empty list - very good !): "
for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | grep -v "0 kB$" | grep " kB$" | sort -k 2 -n -r  | tee -a  $LogFile

echo
entry "File system disk space usage: df -h"
df -h  | tee -a  $LogFile

echo
entry "File system inode usage: df -i"
df -i  | tee -a  $LogFile

echo
entry "Random read/write performance"
$FIO --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio_test --filename=${DIR}/fio_test.tmp --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=50 --append-terse | tee -a $LogFile

echo
entry "Random read performance"
$FIO --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio_test --filename=${DIR}/fio_test.tmp --bs=4k --iodepth=64 --size=4G --readwrite=randread --append-terse | tee -a $LogFile

echo
entry "Random write performance"
$FIO --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio_test --filename=${DIR}/fio_test.tmp --bs=4k --iodepth=64 --size=4G --readwrite=randwrite --append-terse | tee -a $LogFile

echo
entry "Sequential read/write performance"
$FIO --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio_test --filename=${DIR}/fio_test.tmp --bs=4k --iodepth=64 --size=4G --readwrite=rw --rwmixread=50 --append-terse | tee -a $LogFile

echo
entry "Sequential read performance" 
$FIO --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio_test --filename=${DIR}/fio_test.tmp --bs=4k --iodepth=64 --size=4G --readwrite=read | tee -a $LogFile

echo
entry "Sequential write performance"
$FIO --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio_test --filename=${DIR}/fio_test.tmp --bs=4k --iodepth=64 --size=4G --readwrite=write | tee -a $LogFile

echo
entry "Running IOPing"
log "On a healthy system, variation should be very low" | tee -a $LogFile
$IOP -c 10 ${DIR}/ | tee -a $LogFile

# Cleaning up
MSG="Removing temporary files in $DIR failed"
rm -f ${DIR}/fio_test.tmp
errlvl=$?
errors

MSG="Removing temporary directory $DIR failed"
rmdir ${DIR}
errlvl=$?
errors

Unlock $LockFile
