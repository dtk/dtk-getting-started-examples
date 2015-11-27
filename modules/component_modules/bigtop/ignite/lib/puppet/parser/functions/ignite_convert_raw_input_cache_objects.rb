#
# ignite_convert_raw_input_cache_objects.rb
#

module Puppet::Parser::Functions
  newfunction(:ignite_convert_raw_input_cache_objects, :type => :rvalue, :doc => <<-EOS
This function converts input hash object to normalized form, which is a hash of form
  { name:
      cache_object: {
        name:                   ...,
        object_class:           ...,
        qualified_object_class: ...,
        fields:                 ...
      }
  }
    EOS
  ) do |arguments|
    fn = 'ignite_convert_raw_input_cache_objects()' 
    raise(Puppet::ParseError, "#{fn}: Wrong number of arguments " +
      "given (#{arguments.size} for 2)") unless arguments.size == 2

    input_hash = arguments[0]
    cache_object_group_id = arguments[1]

    ret = {}
    return ret if input_hash.is_a?(String) and input_hash.empty?
    
    unless input_hash.is_a?(Hash)
      raise(Puppet::ParseError, "#{fn}: Requires hash input, not: #{input_hash.inspect}")
    end

    # TODO: is there a place we can define constants
    java_field_types = {
      string: 'String',
      long:   'Long'
    }
    input_hash.inject({}) do |h, (name, body)|
      # TODO: make into camel case if has '_'
      object_class           = name.capitalize
      qualified_object_class = "#{cache_object_group_id}.#{object_class}"

      fields = (body['fields'] || {}).map do |field_name, field_info|
        unless type = field_info['type']
          raise(Puppet::ParseError, "#{fn}: Field '#{field}' has missing type")
        end
        unless java_type = java_field_types[type.to_sym]
          raise(Puppet::ParseError, "#{fn}: Field '#{field}' has illegal type '#{type}'")
        end
        qualified_java_type = "java.lang.#{java_type}"
        ascending_index = !!field_info['ascending_index']
        descending_index = !!field_info['descending_index']
        query_field = (ascending_index or descending_index or !!field_info['query_field'])
        {
          name:                field_name,
          java_type:           java_type,
          qualified_java_type: qualified_java_type,
          query_field:         query_field,
          ascending_index:     ascending_index,
          descending_index:    descending_index
        }
      end
      converted_hash = {
        name:                   name,
        object_class:           object_class,
        qualified_object_class: qualified_object_class,
        fields:                 fields
      }
      h.merge(name => {:cache_object => converted_hash})
    end
  end
end

# vim: set ts=2 sw=2 et :
