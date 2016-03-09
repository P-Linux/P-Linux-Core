# General Preparation

<p align="center">Clean any previous setup (user, group, directories etc..) and create the new setup.</p>


---

**TODO: DOCUMENTATION NEEDS TO BE REDONE**

!!! note

    There is no need to execute these steps manually, they are here for information what needs to be done.
    Afterwards execute the automated scripts: [Link To Automated Scripts](#automated-scripts)


**REMEMBER:** This part is done via the **root account** of the host.


## Exporting The 'LFS' Variable

This guide uses a LFS-TARGET-DIR to build the new P-Linux ISO.

Having this variable set is beneficial in that commands such as `mkdir -v $LFS/tools` can be typed literally.

```bash
export LFS='/mnt/lfs'
```


## Checking Architecture

```bash
uname -m
```

Which MUST return

```text
x86_64
```


## Clean Previous Setup

To compile *everything from scratch* it is best to remove any `user`, `group` and `directories` created by a previous
run.

!!! hint

    If you have downloaded  **sources** from a previous build you may want to move them.


### Removing User 'lfs' And Home-Directory

```bash
userdel --force --remove lfs
```

*Options: userdel*

* `-f, --force`: force removal of files, even if not owned by user
* `-r, --remove`: remove home directory and mail spool


### Removing The Group 'lfs'

Normally, by removing the user, the group is removed as well. If not sure run the following command.

```bash
groupdel lfs
```


### Removing Any Existing 'lfs' Target Directory

!!! hint

    Make sure no application accesses `$LFS` or any sub-directories or files

We make sure `$LFS/pkgmk` is not mounted (mountpoint 'pkgmk') see:
[Optional Mounting A RAM Disk](03_optional_preparation.md#mounting-a-ram-disk)

```bash
umount -v pkgmk
rm -rf $LFS
```


### Removing Any Existing Related 'lfs' Links

!!! warning

    Removing host links/directories: Are you sure you want that.

```bash
rm -rf /tools
rm -rf /sources
rm -rf /pkgmk
```


### Removing Previous 'lfs.swap' File

This could exist if you have execute the *Optional Preparation* part.

!!! warning

    Removing host path `/lfs.swap`: Are you sure you want that.

```bash
swapoff /lfs.swap
rm -rf /lfs.swap
```


## Create A New Setup

### Creating Folders & Links

#### Directory 'sources'

A list packages need to be downloaded in order to build a basic P-Linux system. Downloaded packages and patches will need
to be stored somewhere that is conveniently available throughout the entire build.


#### Directory 'tools'

All programs compiled in the pass-1 will be installed under `$LFS/tools` to keep them separate from the programs
compiled in the pass-2. The pass-1 compiles temporary tools and will not be a part of the final P-Linux
system. Keeping them in a separate directorymakes it easier to removem them later.


#### Directory 'pkgmk'

This directory is used by the P-Linux Package Management Utilities [p_cards](https://github.com/P-Linux/p_cards) to
unback and compile the programs.


#### Links

The created symlinks enables the toolchain to be compiled so that it always refers to `/tools` (or the other links),
meaning that all will be accessable in the pass-1 (when we are still using some tools from the host) and in the  pass-2
(when we are “chrooted” to the new P-Linux folder).

The same goes for the other links.


#### To Create The Folders & Links

```bash
mkdir -vp $LFS/{sources,tools,pkgmk}
ln -svf $LFS/tools /
ln -svf $LFS/sources /
ln -svf $LFS/pkgmk /
```

*Options: mkdir*

* `-p, --parents`:   no error if existing, make parent directories as needed


### Creating 'lfs' Group & User

It is recommend to build the packages in pass-1 as an unprivileged user. To set up a clean working environment, we
create a new user called `lfs` as a member of a new group (also named `lfs`). The password for this user is also set to
`lfs`.

```bash
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
echo "lfs:lfs" | chpasswd -m
```

*Options: useradd*

* `-s, --shell SHELL`:   login shell of the new account

    *In our case:* `-s /bin/bash` This makes bash the default shell for user lfs.

* `-g, --gid GROUP`:   name or ID of the primary group of the new account

    *In our case:* `-g lfs` This option adds user lfs to group lfs.

* `-m, --create-home`:   create the user's home directory

* `-k, --skel SKEL_DIR`:   use this alternative skeleton directory

    *In our case:* `-k /dev/null` This parameter prevents possible copying of files from a skeleton directory
    (default is /etc/skel) by changing the input location to the special null device.

* `lfs`: at the end is the actual name for the created user.


*Options: chpasswd*

* `-m, --md5`:   encrypt the clear text password using the MD5 algorithm

    * the command is  like this: `echo "user_name:password_plaintext" | chpasswd -m`


### Setting Owner & Mode Of Folders

Grant user 'lfs' full access to $LFS and sub-directories by making lfs the directory owner:

Make the `$LFS/sources` directory writable and sticky. “Sticky” means that even if multiple users have write permission
on a directory, only the owner of a file can delete the file within a sticky directory.

```bash
chown -v -R lfs $LFS
chmod -v a+wt $LFS/sources
```

*Options: chpasswd*

* `-R, --recursive`:  operate on files and directories recursively


### Creating 'lfs' User Files & Directories

Set up a good working environment by creating two new startup files for the `lfs` bash shell.


#### bash_profile

When logged on as user, the initial shell is usually a login shell which reads the `/etc/profile` of the host
(probably containing some settings and environment variables) and then **.bash_profile**. The `exec env -i.../bin/bash`
command in the **.bash_profile** file replaces the running shell with a new one with a completely empty environment,
except for the HOME, TERM, and PS1 variables. This ensures that no unwanted environment variables from the host system
leak into the build environment.


```bash
cat > "$LFS_USER_BASH_PROFILE" << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
```

#### bashrc

The new instance of the shell is a non-login shell, which does not read the `/etc/profile or .bash_profile files`, but
rather reads the **.bashrc** file instead.


```bash
cat > "$LFS_USER_BASHRC" << EOF
set +h
umask 022
LFS=$LFS
LC_ALL=POSIX
LFS_TGT=$ARCH-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF
```


#### Creating user 'lfs log' Directory

```bash
mkdir -p $LFS_USER_LOGS_DIR
```



---


## Automated Scripts

If you did not manually execute these steps, you can run the automated scripts from the **root  account** of the host.


### 02_general_preparation.sh

See also [Helper Scripts](00_build_an_install_iso.md#helper-scripts)
