module Puppet::Parser::Functions
  newfunction(:dtk_util_merge_arrays_to_hash, :type => :rvalue, :doc => <<-'EOS') do |args|
     args:
       keys - an array
       params_hash - hash where each element is an array
    EOS

    if args.size != 2
      raise Puppet::ParseError, ("dtk_util_merge_arrays_to_hash(): wrong number of arguments (#{args.size}); must equal 2")
    end

    unless args[0].kind_of?(Array)
      raise Puppet::ParseError, ("dtk_util_merge_arrays_to_hash(): first arg must be an array")
    end
    keys = args[0]

    num_keys = keys.size
    unless keys.uniq.size == num_keys
      raise Puppet::ParseError, ("dtk_util_merge_arrays_to_hash(): elements in first argument must be unique")
    end

    unless args[1].kind_of?(Hash)
      raise Puppet::ParseError, ("dtk_util_merge_arrays_to_hash(): second arg must take a hash as its argument")
    end
    params_hash = args[1]

    
    # each value under hash key must be 
    params_hash.each_pair do |k,v|
      unless v.kind_of?(Array)
        raise Puppet::ParseError, ("dtk_util_merge_arrays_to_hash(): value under hash key '#{k}' must be an array")
      end
      if v.size > num_keys
        raise Puppet::ParseError, ("dtk_util_merge_arrays_to_hash(): value under hash key has a size greater than number of keys")
      end
    end

    ret = Hash.new 
    keys.each_with_index do |key,i|
      el_body = Hash.new
      params_hash.each_pair do |k,array|
        if array.size > i
          val = array[i]
          val = nil if val.kind_of?(String) and val == 'nil'
          el_body.merge!(k => val) unless val.nil?
        end
      end
      ret.merge!(key => el_body)
    end
    ret
  end
end
