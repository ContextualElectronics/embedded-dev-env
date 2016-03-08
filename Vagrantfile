# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'lib/better_usb.rb'
require_relative 'lib/calculate_hardware.rb'
require_relative 'lib/os_detector.rb'

puts "Vagrant's Ruby Version: #{RUBY_VERSION}"

if ARGV[0] == "up" then
  has_installed_plugins = false

  #unless Vagrant.has_plugin?("vagrant-vbguest")
  #  system("vagrant plugin install vagrant-vbguest")
  #  has_installed_plugins = true
  #end

  if has_installed_plugins then
    puts "Vagrant plugins were installed. Please run vagrant up again to install the VM"
    exit
  end
end

vagrant_dir = File.expand_path(File.dirname(__FILE__))

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #
  # Ubuntu 14.04 minimal desktop.
  #
  # The following modifications are made to this image:
  #
  # Installed vim
  # Performed Updates and dist-upgrade ( on 06.06.2014 )
  # Removed network-manager
  # Disabled apparmor
  # Removed older kernels
  #
  # The following packages were removed:
  #
  # thunderbird
  # rythmbox
  # empathy
  # ubuntu-docs
  # gnome-user-guide
  # deja-dup
  # xterm
  # remmina
  # transmission
  # brasero
  # cheese
  # totem


  config.vm.box = "kumichou/ce_embedded"
  config.vm.hostname = "ce-virtual-machine"

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.synced_folder(".", "/vagrant",
    :owner => "vagrant",
    :group => "vagrant",
    :mount_options => ['dmode=777','fmode=777']
  )

  config.vm.provider "virtualbox" do |vb|

    # Tell VirtualBox that we're expecting a UI for the VM
    vb.gui = true

    # Give the virtual machine a name
    vb.name = "ContextualElectronics"

    # Turn on USB 2.0 support, requires the VirtualBox Extras to be installed
    vb.customize ["modifyvm", :id, "--usb", "on", "--usbehci", "on"]

    # Enable sharing the clipboard
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]

    # Set # of CPUs and the amount of RAM, in MB, that the VM should allocate for itself, from the host
    CalculateHardware.set_minimum_cpu_and_memory(vb, 2, 2048)

    # Set Northbridge
    vb.customize ["modifyvm", :id, "--chipset", "ich9"]

    # Set the amount of RAM that the virtual graphics card should have
    vb.customize ["modifyvm", :id, "--vram", "128"]

    # Advanced Programmable Interrupt Controllers (APICs) are a newer x86 hardware feature
    vb.customize ["modifyvm", :id, "--ioapic", "on"]

    # Enable the use of hardware virtualization extensions (Intel VT-x or AMD-V) in the processor of your host system
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]

    # Enable, if Guest Additions are installed, whether hardware 3D acceleration should be available
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]

    # Setup rule to automatically attach ST Link v2.1 Debugger when plugging in Nucleo board
    BetterUSB.usbfilter_add(vb, "0x0483", "0x374b", "ST Link v2.1 Nucleo")

    # Setup rule to automatically attach Freescale Debugger when plugging in Nucleo board
    BetterUSB.usbfilter_add(vb, "0x0d28", "0x0204", "Freescale freedom")

    # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]

  end

end
