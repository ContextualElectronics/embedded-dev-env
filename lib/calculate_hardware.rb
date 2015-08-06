$:.unshift File.dirname(__FILE__)

require_relative 'os_detector.rb'

module CalculateHardware

  def self.processor_count
    case OsDetector.os
    when :macosx
      `sysctl -n hw.ncpu`.to_i / 4
    when :linux
      `cat /proc/cpuinfo | grep processor | wc -l`.to_i / 4
    when :windows
      require 'win32ole'
      wmi = WIN32OLE.connect("winmgmts://")
      cpu = wmi.ExecQuery("SELECT NumberOfCores FROM Win32_Processor") # TODO count hyper-threaded in this
      cpu.to_enum.first.NumberOfCores.to_i / 4
    end
  end

  def self.memory_capacity
    case OsDetector.os
    when :macosx
      `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    when :linux
      `grep MemTotal /proc/meminfo | awk '{print $2}'`.to_i / 1024 / 4
    when :windows
      require 'win32ole'
      wmi = WIN32OLE.connect("winmgmts://")
      cpu = wmi.ExecQuery("SELECT Capacity FROM Win32_PhysicalMemory")
      cpu.to_enum.map{|a| a.Capacity.to_i }.inject(:+) / 1024 / 1024 / 4
    end
  end

  def self.set_minimum_cpu_and_memory(vb, cpu_count, memory)
    cpu = CalculateHardware.processor_count
    mem = CalculateHardware.memory_capacity

    if cpu_count > cpu
      cpu = cpu_count
    end

    if memory > mem
      mem = memory
    end

    vb.customize ["modifyvm", :id, "--memory", mem.to_s]
    vb.customize ["modifyvm", :id, "--cpus", cpu.to_s, "--pae", "on"]
  end
end
