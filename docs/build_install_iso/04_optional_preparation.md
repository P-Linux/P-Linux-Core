# Optional Preparation

<p align="center">Speed up compilation using RAM Disk & SAWP File.</p>


---

**TODO: DOCUMENTATION NEEDS TO BE REDONE**


!!! note

    You can execute these steps manually or run automated scripts AFTER reading them:
    [Link To Automated Scripts](#automated-scripts)

**REMEMBER:** This part is done via the **root account** of the host.


This part is optional but higly recommended.


## Mounting A RAM Disk

One way to reduce disk access and prolonging the life of the disk **as well as to speed up compilation** in many cases, 
is by using a RAM Disk.

Note you need a decent amount of ram that is dynamically used (this won't be used when you are not building a package).
Recommended are 4 GiB or more.


### Mounting '/pkgmk' as type: tmpfs

Set **size=80%** or a defined number e.g. **size=3G**


```bash
mount -v -t tmpfs -o defaults,noatime,size=80%  pkgmk /pkgmk
```

!!! hint

    This is only temporar, in case you reboot the host during the following steps: you must re-do this.
    
**NOTE for later**: since you are now compiling in memory there is no point in keeping a compiler flag `-pipe` as this 
will decrease performance.


#### Verify 'pkgmk' tmpfs Is Enabled

```bash
df -h
```


## Creating A SWAP-File

Example uses 6GiB

```bash
fallocate -l 6G /lfs.swap
```

If fallocate fails or is not installed, use the `dd` command to create the file.


### Formating The SWAP-File

```bash
mkswap /lfs.swap
```


### Optional 'chmod' The SWAP-File

```
chmod 600 /lfs.swap
```


### Enable The SWAP-File

```bash
swapon /lfs.swap
```


### Verify iThe SWAP-File Is Enabled

```bash
free -h
```



## Useful Commands

One can run this in another terminal during compilation.


### To Check RAM/SWAP Usage

```bash
free -h
```

---


## Automated Scripts

If you did not manually execute these steps, you can run the automated scripts from the **root  account** of the host.


### 03_optional_preparation.sh

See also [Helper Scripts](00_build_an_install_iso.md#helper-scripts)
