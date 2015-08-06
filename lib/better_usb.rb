$:.unshift File.dirname(__FILE__)

require_relative 'os_detector.rb'


module BetterUSB

  def self.usbfilter_exists(vendor_id, product_id)
    #
    # Determine if a usbfilter with the provided Vendor/Product ID combination
    # already exists on this VM.
    #
    # TODO: Use a more reliable way of retrieving this information.
    #
    # NOTE: The "machinereadable" output for usbfilters is more
    #       complicated to work with (due to variable names including
    #       the numeric filter index) so we don't use it here.
    #

    machine_id_filepath = File.join(".vagrant","machines","default","virtualbox","id")

    unless File.exists? machine_id_filepath
      return false
    end

    if OsDetector.os == :windows
      if File::ALT_SEPARATOR
        machine_id_filepath.gsub!(File::SEPARATOR, File::ALT_SEPARATOR)
      end
      machine_id = `type #{machine_id_filepath}`
      vm_info = `"C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe" showvminfo #{machine_id}`
    elsif [:macosx, :linux].include? OsDetector.os
      vm_info = `VBoxManage showvminfo $(<#{machine_id_filepath})`
    end

    result = vm_info=~/(VendorId:\s+#{vendor_id.sub('0x', '')})\n(ProductId:\s+#{product_id.sub('0x', '')})/

    return result
  end

  def self.usbfilter_add(vb, vendor_id, product_id, filter_name)
    #
    # This is a workaround for the fact VirtualBox doesn't provide
    # a way for preventing duplicate USB filters from being added.
    #
    # TODO: Implement this in a way that it doesn't get run multiple
    #       times on each Vagrantfile parsing.
    #

    unless usbfilter_exists(vendor_id, product_id)
      vb.customize ["usbfilter", "add", "0",
                    "--target", :id,
                    "--name", filter_name,
                    "--vendorid", vendor_id,
                    "--productid", product_id
                    ]
    end
  end

end
