Puppet::Type.type(:dtk_util_export_variable).provide(:ruby) do
  def create
    content = resource[:content]
    Puppet.send(resource[:loglevel], "exporting variable under #{resource[:name]}")
    cmp_name,attr_name = parse_name(resource[:name])    
    cmp_info = (Thread.current[:exported_variables] ||= Hash.new)[cmp_name] ||= Hash.new
    cmp_info[attr_name] = content
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
