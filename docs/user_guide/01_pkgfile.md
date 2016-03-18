# Pkgfile

<p align="center">Pkgfile information and How to</p>


---


## Pkgfile Introduction


## Pkgfile-Header

A *P-Linux Pkgfile* REQUIRES a *Pkgfile-Header* in the following format:

| Required | Variable Name | Description                                         | Type |
|:--------:|:--------------|:----------------------------------------------------|:-------------------|
| YES      | `description` | A short description of the package                  | String |
| YES      | `url`         | An URL that is associated with the software package.| String |
| YES      | `maintainer`  | Name, pseudonym , e-mail address or web-link | String |
| YES      | `depends`     | A list of dependencies. | array|


Example Pkgfile-Header:

```bash
description="Terminal based IRC client for UNIX systems"
url="http://www.irssi.org/"
maintainer="peter1000 <https://github.com/peter1000>"
depends=(glib)
```


## Pkgfile-Variables

Additionally to the *Pkgfile-Header* above, following variables are used:

| Required | Variable Name | Description                                         | Type |
|:--------:|:--------------|:----------------------------------------------------|:-------------------|
| YES      | `name`        | The name of the package to build.               | String |
| YES      | `version`     | The version of the main source of the package. | String |
| YES      | `release`     | This value is typically set to 1 for each new upstream software release and incremented for intermediate updates. | String |
| YES      | `source`      | A list of dependencies needed to build or run the package. | array|


Example Pkgfile-Variables:

```bash
name=gnome-terminal
version=2.6.4
release=1
source=(http://ftp.gnome.org/pub/gnome/sources/$name/${version%.*}/$name-$version.tar.bz2)
```

Avoid introducing new variables, other names could be in conflict with internal variables.


## Pkgfile-Functions

There are a number of *Pkgfile functions* which are automatically executed by the build process.

| Required | Function Name | Description                                         |
|:--------:|:--------------|:----------------------------------------------------|
| YES      | `build() `    | The main function to build he package.           |
| NO      | `devel() `    | TODO XXX          |


Example Pkgfile-Functions:

```bash
build() {
cd $name-$version
./configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info
make
make DESTDIR=$PKG install
}
```
