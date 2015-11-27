module Puppet::Parser::Functions
  newfunction(:dtk_util_array_hash_to_hash, :type => :rvalue, :doc => <<-'EOS') do |args|
     args:
       array - each element is a single key hash
    EOS

    if args.size != 1
      raise Puppet::ParseError, ("array_hash_to_hash(): wrong number of arguments (#{args.size}); must equal 1")
    end
    unless args[0].kind_of?(Array)
      raise Puppet::ParseError, ("array_hash_to_hash(): must take an array as its argument")
    end
    array = args[0]
    if array.find{|el|!el.kind_of?(Hash)}
      raise Puppet::ParseError, ("array_hash_to_hash(): elements must be hashes")
    end

    #TODO: allow an option that raises error if conflicting resources; heer last one overwrites
    array.inject(Hash.new){|h,el|h.merge(el)}
  end
end
