## Generally useful notes for FreeBSD


### Copy system packages to a new machine

```pkg prime-origins > pkglist.txt```

On the source system, scp the file to new and run

```cat pkglist.txt | xargs pkg install -y```

