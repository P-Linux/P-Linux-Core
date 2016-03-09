# P-Linux vs. NuTyX-Linux

<p align="center">Main differences between P-Linux and NuTyX-Linux.</p>


---


## 01. Acknowledgment

**Many thanks to the author of the NuTyX-Linux project: Thierry Nuttens and all the other contributors.**

[P-Linux](https://github.com/P-Linux) is a [NuTyX-Linux](https://github.com/NuTyX) derived Linux system,
which means it has much in common with NuTyX-Linux. Below are some of the differences.


## 02. Architecture

**NuTyX-Linux**: does support more architectures: e.g. `i686` and more recently `ARM`.

**P-Linux**: is only for 64-bit (x86_64) architecture. At the moment there are no plans to support any other 
architecture.


## 03. Language Support

### Documentation

**NuTyX-Linux**: main documentation is in French with partial support for English and some other languages.

**P-Linux**: The documentation is mostly rewritten from scratch: mainly in English. 
There are future plans to add German and Portuguese language documentation.


### Scripts

**P-Linux**: the P-Linux-Core scripts are rewritten from scratch with support for *gettext native language translation*.

NOTE: Some of those changes are backported to NuTyX-Linux.


## 04. Package Manager

**P-Linux**: Package Management Utilities [p_cards](https://github.com/P-Linux/p_cards/) is based on a fork 
(07. March 2016) of the original [NuTyX-Linux cards](https://github.com/NuTyX/cards).

**p_cards** tries to be compatible with the original cards package.


### Features - Differences

**P-Linux**: Thiese features  below were backported to NuTyX-Linux cards as experiemental.

* Added support for sources of version control systems: `Bazaar, Git, Subversion, and Mercurial`
* Added support to rename source files
* Added support to skip auto-extraction per source array entry
* Added support to `pkgmk.in` for gettext native language translation


**P-Linux**: 

* Added support to auto-extract source files of type: `rpm and deb`






