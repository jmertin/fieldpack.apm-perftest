#!/bin/bash
#
# Author: $Author: jmertin $
# Locked by: $Locker:  $
#
# This script will gather all information required for troubleshooting Networking issues
# with the TIM software

# I want it to be verbose.
VERBOSE=false

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

# IP
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

# Log program version.
MSG="$LDATE `whoami`@`hostname` - ${PROGNAME}.sh version $VER"
title $MSG


MSG="Creating logfile $LogFile"
echo -n > $LogFile
errlvl=$?
errors

# Set a title for the script
title "Disk performance IOPS test"

if [ "$USER" != "root" ]
then

    MSG="This script requires root access, as regular users could be\n\tsubject to limitations applied by the OS"
    errlvl=1
    errors
fi


FIO=$( which fio 2>/dev/null )

if ! [ -x "$(command -v ${FIO})" ]
   then
    MSG="fio binary not found in path. Please install or adapt PATH variable"
    errlvl=1
    errors
fi

IOP=$( which ioping 2>/dev/null )

if ! [ -x "$(command -v ${IOP})" ]
then       
    MSG="ioping binary not found in path. Please install or adapt PATH variable"
    errlvl=1
    errors  
fi

echo "The test directory needs to be situated on the disk/partition"
echo "that is to be tested. It will be created if non-existent."
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


entry "Random read/write performance"
echo "Random read/write performance"

$FIO --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio_test --filename=${DIR}/fio_test.tmp --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75 | tee -a $LogFile

entry "Running IOPing"
echo "Running IOPing"
echo "On a healthy system, variation should be very low" | tee -a $LogFile
$IOP -c 10 ${DIR}/ | tee -a $LogFile

# Cleaning up
MSG="Removing temporary files in $DIR failed"
rm -f ${DIR}/*
errlvl=$?
errors

MSG="Removing temporary directory $DIR failed"
rmdir ${DIR}
errlvl=$?
errors

Unlock $LockFile
