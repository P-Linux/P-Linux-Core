# Build A P-Linux Install ISO

<p align="center">The aim of this short guide is to build /rebuild a 'Base P-Linux' installation ISO file.</p>


---


## Overview

The target audience is a user who wants a clean and solid Linux distribution build from scratch.

This is based on the online documentation [Linux From Scratch (LFS)](http://www.linuxfromscratch.org/lfs/) and
most steps are automated and only a few require manual intervention.
It is still recommendet that you checkout the *Linux From Scratch* webpage.

!!! note

    The 64-bit build that results from this is considered a "pure" 64-bit system.
    That is, **it supports 64-bit executables only**.

The finished ISO file can be burned on CD/DVD or written unto an USB-Stick. These can be used to install **P-Linux**
systems.


## Helper Scripts

There are helper scripts in the directory: `P-Linux-Core/scripts/build_install_iso`

To run a script excute: `bash path_to_script`

Each section of this guide will mention related scripts.

**NOTE**: at the end of each section there are also references to related helper scripts.

!!! hint

    At the very end there is one automated helper script which executes all steps at once.


## Download P-Linux-Core

To proceed you must download a copy of **P-Linux-Core** which includes the automated scripts of this documentation.


### Tested Release

For the released tested version: see [P-Linux-Core releases ](https://github.com/P-Linux/P-Linux-Core/releases)


### Latest Development Source

For the latest development version (this might be broken at any time) run:

```bash
git clone git://github.com/P-Linux/P-Linux-Core.git P-Linux-Core_current
```
