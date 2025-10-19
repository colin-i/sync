# Action SWF

## Install
On Ubuntu(amd64 i386)(bionic focal jammy noble) from PPA.
```sh
sudo add-apt-repository ppa:colin-i/ppa
```
Or the *Manual installation step* from this [link](https://gist.github.com/colin-i/e324e85e0438ed71219673fbcc661da6):
```sh
sudo apt-get install actionswf
```
There is also <i>libactionswf-dev</i>(all). <i>liboadbgdata</i> <i>.gz</i> file from [releases](https://github.com/colin-i/actionswf/releases) is for aarch64 architecture.\
\
\
On Arch Linux(x86_64), <i>.zst</i> file from [releases](https://github.com/colin-i/edor/releases). Or:
```sh
yay -Sy actionswf
```
\
On Fedora 42(x86_64):
```sh
sudo dnf copr enable colin/project
sudo dnf install actionswf
```
There is also <i>actionswf-devel</i>(noarch).\
\
\
On openSUSE(x86_64), run the following as __root__:\
For openSUSE Tumbleweed:
```sh
zypper addrepo https://download.opensuse.org/repositories/home:costin/openSUSE_Tumbleweed/home:costin.repo
```
For openSUSE Leap:
```sh
zypper addrepo https://download.opensuse.org/repositories/home:costin/openSUSE_Leap_16.0/home:costin.repo
```
Replace *16.0* with *15.6* if needed.\
And:
```sh
zypper refresh
zypper install actionswf
```
An optional step is to install **actionswf-devel**(noarch).\
\
\
On Windows, <i>.windows.zip</i> file from [releases](https://github.com/colin-i/actionswf/releases).

## From source
Compile with [O Compiler](https://github.com/colin-i/o).

## Info
A brief intro is at [readme.txt](https://raw.githubusercontent.com/colin-i/actionswf/master/readme.txt).\
Games by this program at [kongregate](https://www.kongregate.com/accounts/bitplayer/games?filter=favorites&sort=gameplays).

[//]: # (https://www.kongregate.com/games/bitplayer)
<!--- but with no sort --->

## Donations
The *Donations* section is [here](https://gist.github.com/colin-i/e324e85e0438ed71219673fbcc661da6).
