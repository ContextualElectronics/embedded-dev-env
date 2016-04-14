# Vagrant-based VirtualBox environment for STM32 ARM Development using Ubuntu 14.04 Server

## Attention!

This project requires a relatively recent computer that supports Hardware Virtualization. You MUST make sure you have AMD-V or VT-x extensions enabled in your computer's BIOS otherwise the Virtual Machine will not boot!

If you encounter other problems, check out the [Gotchas](#gotchas) section below

## Host OS Requirements

*  Windows 7 or higher, or Mac OS X Mountain Lion or higher
*  About 15GB of Free Space on OS hard drive

## Prerequisites before you begin building the virtual machine

*  Install VirtualBox v5.0.16 [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
*  Install VirtualBox Extension Pack v5.0.16 [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
*  Install Vagrant v1.8.1 [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)
*  If you haven't already installed the above items, you will most likely be asked to reboot your computer, please do so before continuing...

## Building the environment for the first time

*  Download a copy of this repository as a zip file
*  Unzip on your local system
*  Open a terminal/command prompt (if on Windows, launch command window as an Administrator), navigate to the unzipped folder, execute `vagrant up`
*  If you have never used Vagrant before, Vagrant will try to install some required plugins the first time you execute `vagrant up`. Vagrant will install them first, prompt for you to restart `vagrant up`, then exit the program. Execute `vagrant up` to continue building the Virtual Machine after the plugins install.
*  Go get something to drink, eat, or otherwise occupy your time as it will take a while to download the 2.1+GB base box from the Atlas cloud.
*  Eventually you will have an Ubuntu Desktop that is prompting you to log in. The password is `contextual`

## Installed Tools

*  Eclipse 4.5 (Mars)
*  Eclipse CDT for C/C++
*  EmbSysRegViewer for Eclipse
*  TCF Terminal View for Eclipse
*  GNU ARM Plugin for Eclipse
*  ATOM Text Editor
*  Evince PDF Reader
*  Vim Text Editor
*  ack-grep
*  Git
*  Subversion
*  Mercurial
*  Bazaar
*  stlink command line tools
*  OpenOCD 0.10.x (most current source code)
*  GNU ARM Tools 2016-Q1 Release
*  Firefox web browser
*  KiCAD EDA Software Suite
*  CoolTerm
*  Putty SSH Client
*  Unity Tweak Tool (adjust Unity UI performance)
*  OpenSCAD
*  FreeCAD

## Installed Programming Languages

*  GNU C/C++
*  Python 2.7.6
*  Python 3.4.3
*  Ruby 2.2.4
*  NodeJS 5.4.1 (npm 3.3.12)
*  Perl 5.18.2
*  OpenJDK 7
*  Go >= 1.6
*  Rust >= 1.4.x
*  Elixir >= 1.2.x

## Removing the Dev Environment Image from your hard drive

*  Open a terminal, navigate to the unzipped folder, execute `vagrant destroy` This will delete the VM from your system.

## Updating from an older version of the image

The Vagrant system doesn't allow you to update/upgrade your existing image to a newer one. You will be required to back up your ~/.ssh/ directory (and make sure all of your code is checked into a remote source code repository) then you can `vagrant destroy` your existing image, pull down the latest code from the ContextualElectronics GitHub repo for stm32-eclipse-linux-trusty64 then you can `vagrant up` to build the new version of the environment. After that is complete, don't forget to restore the contents of your ~/.ssh/ directory so that your SSH key will match what you have previously.

## Gotchas

If you are using Windows and receive an error that the Vagrant Home Directory can't have spaces in it due to a bug in Ruby, your User home directory probably has a space in it.

* Create a folder "home" within C:\Hashicorp\Vagrant - `C:\Hashicorp\Vagrant\home` ( This assumes you used the default install directory for Vagrant )
* Add the environment variable `VAGRANT_HOME` to Windows, see [http://www.computerhope.com/issues/ch000549.htm](http://www.computerhope.com/issues/ch000549.htm) if you don't know how.
* Reboot your system for the new environment variable to take effect.
* Try again...

There has been a security update to Windows 10 that prevents the vagrant-vbguest plugin from working properly. If you are using Windows 10 and downloaded an earlier version of this repository, please remove the VBGuest plugin by running `vagrant plugin uninstall vagrant-vbguest`. When the plugin is updated with a workaround, we will update the Vagrantfile in the project to make sure that the plugin is installed on the Host OS system.

### Confirm VT-x or AMD-V CPU Extension Support

Check your CPU on the Intel website to see if it supports VT-x. If you have an AMD processor, confirm that it supports AMD-V extensions. Then, make sure to turn on Virtualization support in your BIOS. Apple computers that have a compatible Intel processor already have the VT-x extensions enabled in EFI.

### Hyper-V interfering with VirtualBox

If needed, turn off Hyper-V (go to Windows Features on your machine and uncheck Hyper-v – in Win10 use the search box on the bottom toolbar to get to the Windows Features)

