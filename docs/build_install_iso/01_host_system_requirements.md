# Host System Requirements

<p align="center">What must the current operating system support.</p>


---

This information is based on
[Linux From Scratch (LFS) - Host Requirements](http://www.linuxfromscratch.org/lfs/view/development/prologue/hostreqs.html).

!!! note

    There might be differences between OUR REQUIREMENTS and what LFS suggests.


## Related Helper Scripts

See also [Helper Scripts](00_build_an_install_iso.md#helper-scripts)


### version-check.sh

Listing version numbers of critical development tools.


### library-check.sh

Checking for some library consistency.

EXAMPLE output:

```bash
root [ /P-Linux-Core/scripts/build_install_iso ]# bash library-check.sh

====> Checking for some library consistency...

       libgmp.la: not found
       libmpfr.la: not found
       libmpc.la: not found

====> NOTE....
    -> The files identified by this script should be all present
    ->           or all absent, but not only one or two present.
```


## Host System

**OFFICIAL TESTED HOST SYSTEM**: [P-Linux](https://github.com/P-Linux)

Your host system MUST be a Linux system for 64-bit (x86_64) architecture. At the moment there are no plans to
support any other architecture.

The recommended host system in this order:

* [P-Linux](https://github.com/P-Linux)
* [NuTyX-Linux](https://github.com/NuTyX)
* but most modern 64-bit Linux distributions should be fine too.

**Root privileges** on the host system are required.


## Host Required Software

**OFFICIAL TESTED HOST SOFTWARE**: [P-Linux](https://github.com/P-Linux) with the versions indicated.

!!! note

    Many distributions will place software headers into separate `developmet packages`, often called
    **package-name-devel** or **package-name-dev**. Be sure to install those if your distribution provides them.



Following software should be installed **earlier or later versions** of the listed software packages may work,
but have not been tested.


### Bash 4.3.39

Bash: (/bin/sh should be a symbolic or hard link to bash)

!!! warning

     Make sure you use only the **BASH interpreter** during this guide.


### Binutils 2.25.1


### Bison 3.0.4

Bison: (/usr/bin/yacc should be a link to bison or small script that executes bison)


### Bzip2 1.0.6


### Coreutils 8.24


### Diffutils 3.3


### Findutils 4.4.2


### Gawk 4.1.3

Gawk: (/usr/bin/awk should be a link to gawk)


### GCC (including the C++ compiler) 5.3.0

#### C++ 5.3.0

!!! note

    It is important to checking for some library consistency:
    See [Related Helper Scripts](#related-helper-scripts).


### Glibc 2.22


### Grep 2.23


### Gzip 1.6

### Linux Kernel 3.18.27

!!! note

    Absolute minimum required kernel version is: 2.6.32

    The reason for the minimum kernel version requirement is
    that we specify that version when building glibc at the recommendation of the developers.
    It is also required by udev.


### M4 1.4.17


### Make 4.1


### Patch 2.7.5


### Perl 5.22.1


### Sed 4.2.2


### Tar 1.28


### Texinfo 6.0


### Xz 5.2.2


### Git 2.7.1


### Wget 1.17.1


### Util-linux 2.27
