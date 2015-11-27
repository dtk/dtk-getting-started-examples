Puppet::Type.type(:dtk_util_export_file).provide(:ruby) do
  def create
    filename = resource[:filename]
    unless File.exists?(filename)
      raise Puppet::Error, "File #{resource[:filename]} does not exist"
    end

    Puppet.send(resource[:loglevel], "exporting #{filename} for #{resource[:name]}")
    cmp_name,attr_name = parse_name(resource[:name])    
    cmp_info = (Thread.current[:exported_files] ||= Hash.new)[cmp_name] ||= Hash.new
    cmp_info[attr_name] = filename
    nil
  end

  # want it to eexcute every time called
  def exists?
    false
  end
  def destroy()
  end

 private
  # returns [cmp_name,attr_name]
  def parse_name(name)
    if name =~ /(^.+)\.(.+$)/
      cmp_name = $1
      attr_name = $2
      [cmp_name,attr_name]
    else
      raise Puppet::Error, "ill-formed name paarmter: #{name}"
    end
  end
end
