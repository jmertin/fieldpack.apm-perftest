# fieldpack.apm-perftest 0.1-5 by J. Mertin -- joerg.mertin(-AT-)ca.com
Purpose: Provides a script-set to test performance of actual system to evaluate APM capabilities

# Description
The apm-perftest script will test the disk-io capability to run the
APM software under load.

## Short Description
This script will use fio and ioping to determine the current disk I/O
performance of a system.

In FIO - look for the IOPS entries (Read and Write).

In IOPing - look for a small variation on I/O Times.


## Installation Instructions

#### Installation

- Download and unpack the apm-perfcheck fieldpack on the
  directory/partition that needs to be tested.
- Under RedHat/CentOS, install the fio and ioping packages:

  `~# sudo yum install fio ioping`

This should install all dependencies in the process.


#### Usage Instructions

Just run the run_perftest.sh script as shown below.

```
[merjr01@apm-docker ~]$ tar zxvf apm-perftest.tar.gz 
apm-perftest/share/apm-share.mod
apm-perftest/.build
apm-perftest/CHANGELOG
apm-perftest/README.md
apm-perftest/run_perftest.sh
[merjr01@apm-docker ~]$ cd apm-perftest
[merjr01@apm-docker apm-perftest]$ ./run_perftest.sh 
Random read/write performance
fio_test.tmp: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=64
fio-2.2.8
Starting 1 process
...
```
A complete log will be dumped in the log-file on the system


## Limitations
This script requires fio and ioping to be installed on the system and
made available in the regular PATH


## License
This field pack is provided under the [Eclipse Public License, Version
1.0](LICENSE.txt).

## Support
This document and associated tools are made available from CA
Technologies as examples and provided at no charge as a courtesy to
the CA APM Community at large. This resource may require modification
for use in your environment. However, please note that this resource
is not supported by CA Technologies, and inclusion in this site should
not be construed to be an endorsement or recommendation by CA
Technologies. These utilities are not covered by the CA Technologies
software license agreement and there is no explicit or implied
warranty from CA Technologies. They can be used and distributed freely
amongst the CA APM Community, but not sold. As such, they are
unsupported software, provided as is without warranty of any kind,
express or implied, including but not limited to warranties of
merchantability and fitness for a particular purpose. CA Technologies
does not warrant that this resource will meet your requirements or
that the operation of the resource will be uninterrupted or error free
or that any defects will be corrected. The use of this resource
implies that you understand and agree to the terms listed herein.

Although these utilities are unsupported, please let us know if you
have any problems or questions by adding a comment to the CA APM
Community Site area where the resource is located, so that the
Author(s) may attempt to address the issue or question.

Unless explicitly stated otherwise this field pack is only supported
on the same platforms as the regular APM Version. See [APM
Compatibility Guide](http://www.ca.com/us/support/ca-support-online/product-content/status/compatibility-matrix/application-performance-management-compatibility-guide.aspx).

## Categories
Database Reporting Server Monitoring




# Manual Changelog
```
Mon Dec 11 09:18:56 EST 2017
	- Initial release
	
================================================================================
```
