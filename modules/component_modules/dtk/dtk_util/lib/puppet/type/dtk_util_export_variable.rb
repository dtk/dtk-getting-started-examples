Puppet::Type.newtype(:dtk_util_export_variable) do
  desc <<-EOT
    DTK utility to send back to DTK server an attribute value
  EOT

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc "component and attribute name in dot notation; component if not singleton will have title"
  end

  newparam(:content) do
    desc "content"
  end
end

