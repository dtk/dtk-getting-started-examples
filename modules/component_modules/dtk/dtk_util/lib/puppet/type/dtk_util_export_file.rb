Puppet::Type.newtype(:dtk_util_export_file) do
  desc <<-EOT
    DTK utility to send back to DTK server values computed during execution, stored as file content
  EOT

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc "component and attribute name in dot notation; component if not singleton will have title"
  end

  newparam(:filename) do
    desc "file name"
  end
end

