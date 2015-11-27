#
# dtk_util_select_value.rb
#

module Puppet::Parser::Functions
  newfunction(:dtk_util_select_value, :type => :rvalue, :doc => <<-EOS
This function returns the first defined, non null element or nil

*Examples:*

    dtk_util_select_value('component::master::address','component::worker::address')
    where 
     $component::master is not defined 
     $component::worker = '10.2.2.1'
     
Would return: '10.2.2.1'
    EOS
  ) do |arguments|
    if non_nil_var = arguments.find{|var|!lookupvar(var).nil?}
      lookupvar(non_nil_var)
    else
      :undef
    end
  end
end


