# fieldpack.apm-perftest 0.1-92 by J. Mertin -- joerg.mertin(-AT-)ca.com
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


- Download and unpack the apm-perfcheck fiedlpack
- Under RedHat/CentOS, install the fio and ioping packages:

  `~# sudo yum install fio ioping`

This should install all dependencies in the process.

In case the system cannot install files from an external repository,
check the rhel6/rhel7 directories for pre-build RPM packages.
Note that the packages can be removed after the test.



#### Installation

Install the script-collection by unpacking it into a directory of your
choice, or cloning it through github.

`[caadmin@localhost ~]$ unzip ~/Downloads/fieldpack.apm-scripts-master.zip`


#### Configuration

The CLUI will request data if required. Running the script
`apm-interact.sh` the first time will request optional information as
Customer Name, contact EMail and Ticket/Case number if existing. This
data will be written into the resulting data-logfile.

_Note: the data is stored in a text-file inside the same directory and
sourced to provide defaults on the next execution of the script. This
is also done for every called subroutine._

#### Usage Instructions

The script provides a command-line interface and tries to guess most
of the data required itself. In case there are choices or unknown
elements, the user will have to enter the data interactively

_Note: In case the script does require superuser access, it will ask
so using sudo prior the subroutine call._

After executing `./apm-interact.sh` (_Note the **`./`** in front_), the user
will be presented with the following CLUI:
```
[caadmin@localhost ~]$ cd fieldpack.apm-scripts-master/
[caadmin@localhost fieldpack.apm-scripts-master]$ ./apm-interact.sh  
[sudo] password for caadmin:   
 >> Customer Name [CA Test]:  
 >> Name + EMail [demo.user@nodomain.com]:  
 >> Support Ticket Nr. [123456]:  
One line description of issue: 
================================================================================  
health-check data capture

Chose the action to perform  
================================================================================  
 * CIPHER: Verify cipher compatibility between this TIM and a remote HTTPS Server  
 * EM: Extracts logs on APM EM/MoM  
 * EXIT: Exit data collection  
 * HWCOLL: Collects hardware info for running TIM (RedHat/CentOS only)  
 * PCAP: Generates a packet capture  
 * PHP: Extracts log information on APM PHP Agent  
 * PSQL: Checks PostgreSQL DB status and content  
 * SYS: Performs a system log extraction  
 * TIM: Extracts log information on APM TIM  
 * TIMPERF: Collects performance data on currently running TIM  
================================================================================  
 >> Choose action: 
```
Choose the action to perform: em or EM to extract logs for a EM installation.  
_Note: The commands are case insensitive. You can also type q or Q to exit._

Please only execute the data-collection where it makes sense:

| FUNCTION | TIMPERF | TIM | SYS | PSQL | EM | CIPHER | HWCOLL | PCAP |
|---------:|:-------:|:---:|:---:|:----:|:--:|:------:|:------:|:----:|
| TIM	   |	X    |  X  |  X  |      |    |   X    |   X    |   X  |
| MTP 	   |	X    |  X  |  X  |      |    |   X    |   X    |   X  |
| EM 	   |	     |     |  X  |      |  X |   X    |   X    |      |
| MoM	   |	     |     |  X  |   X  |  X |   X    |   X    |      |
|TESS v4.5 |	     |     |  X  |   X  |  X |   X    |   X    |      |


_Note2: All systems and applications are different. Sometimes a
program will not be found at the right location or the arguments of
the programs have changed through a new version. In that case - errors
may show up during data collection, but these will be interpreted as
non fatal and hopefully the next function will be executed. In case
the execution stops, open an issue_

## Limitations
This script-collection is only meant to run on RedHat/CentOS 5.x or
6.x. It may run on other Linux distributions, but that is no garantee.



## License
This field pack is provided under the [Eclipse Public License, Version
1.0](https://github.com/CA-APM/fieldpack.apm-scripts/blob/master/LICENSE).

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


### Support URL
https://github.com/CA-APM/fieldpack.apm-scripts/issues


## Categories
Database Reporting Server Monitoring




# Manual Changelog
```
Mon Dec 11 09:18:56 EST 2017
	- Initial release
	
================================================================================
```
