# STEGOMATE
## Automates the process of finding hidden data in files.

![alt text](https://github.com/Knowledge-Wisdom-Understanding/StegoMate/blob/master/Stegomate.PNG)

Note on installation. Most of the tools in this project come pre-installed on kali linux and are available from the default Debian package manager Apt. However you may have to install stegcracker using pip3.

```
pip3 install stegcracker

or

python3 -m pip install stegcracker
```

### INSTALLATION
```
cd /opt
git clone https://github.com/Knowledge-Wisdom-Understanding/StegoMate.git
cd StegoMate
chmod +x stegomate.sh
```

### Usage:
```
./stegomate.sh -f <file> -o <outputfile>
./stegomate.sh -f <file>
./stegomate.sh -a
```

After dumping all the strings from the target file, stegomate will attempt to base64 decode every string and and show you the comparison in the steg_report file that is generated.

### See the help menu for more details on available options
### Will be adding more soon as this is an active project.
# Stay Tuned.
