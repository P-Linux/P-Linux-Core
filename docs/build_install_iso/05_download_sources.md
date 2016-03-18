# Download Sources

<p align="center">Download all needed sources in order to build a basic P-Linux system.</p>


---


An easy way to download all of the packages and patches is by using the supplied `wget_base_list` as an input to wget. 
For example:

```bash
wget --input-file=wget-list --continue --directory-prefix=$SOURCES_LINK
```


