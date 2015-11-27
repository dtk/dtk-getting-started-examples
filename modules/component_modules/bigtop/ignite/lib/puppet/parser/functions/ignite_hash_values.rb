#
# ignite_hash_values
#

module Puppet::Parser::Functions
  newfunction(:ignite_hash_values, :type => :rvalue, :doc => <<-EOS
This function  converts from form:
 { name:
      cache_object: {
        name:                   ...,
        object_class:           ...,
        qualified_object_class: ...,
        fields:                 ...
      }
  }
to
[ {
        name:                   ...,
        object_class:           ...,
        qualified_object_class: ...,
        fields:                 ...
      }
]

    EOS
  ) do |arguments|
    fn = 'ignite_hash_values()' 
    raise(Puppet::ParseError, "#{fn}: Wrong number of arguments " +
      "given (#{arguments.size} for 1)") unless arguments.size == 1

    input_hash = arguments[0]

    ret = []
    return ret if input_hash.is_a?(String) and input_hash.empty?

    unless input_hash.is_a?(Hash)
      raise(Puppet::ParseError, "#{fn}: Requires hash input, not: #{input_hash.inspect}")
    end
    input_hash.values.map{ |v| v[:cache_object] }
  end
end
