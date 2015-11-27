#
# bigtop_global
#

module Puppet::Parser::Functions
  newfunction(:bigtop_global, :type => :rvalue, :doc => <<-EOS
This function  returns bigtop globals
first arg is an attribute value and second is an optional default value
    EOS
  ) do |arguments|
    fn = 'bigtop_global()'
    raise(Puppet::ParseError, "#{fn}: Wrong number of arguments " +
          "given (#{arguments.size} for 1 or 2)") unless [1, 2].include?(arguments.size)

    global_attr = arguments[0]
    default_value = arguments[1]
    unless global_attr.is_a?(String)
      raise(Puppet::ParseError, "#{fn}: First argument must be a string")
    end

    function_hiera(["bigtop_global::#{global_attr}", default_value].compact)
  end
end
