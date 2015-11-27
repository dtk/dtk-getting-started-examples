#
# dataset_process_file_wild_cards
#

module Puppet::Parser::Functions
  newfunction(:dataset_process_file_wild_cards, :type => :rvalue, :doc => <<-EOS
This function  returns an array of files from its input that might have wild cards
first arg is an attribute value and second is an optional default value
    EOS
  ) do |arguments|
    fn = 'dataset_process_file_wild_cards()'
    raise(Puppet::ParseError, "#{fn}: Wrong number of arguments " +
          "given (#{arguments.size} for 1)") unless arguments.size == 1

    file_pattern = arguments[0]
    unless file_pattern.is_a?(String)
      raise(Puppet::ParseError, "#{fn}: First argument must be a string")
    end

    # find all wild card patterns and then take cartesian product    
    wildcard_regexp = /\{([0-9]+)\.\.([0-9]+)\}/
    wildcard_sub = /(\{[0-9]+\.\.[0-9]+\})/

    subs = []
    processed_file = file_pattern
    index = 1
    while processed_file =~ wildcard_regexp do
      lower = $1
      upper = $2
      if lower.to_i > upper.to_i 
        raise(Puppet::ParseError, "#{fn}: File pattern given with lower range value '#{lower}' greater than upper range value '#{upper}'")
      end
      
      # look for leading 0s
      leading_zeros = ''
      if lower =~ /(^0+)./
        leading_zeros = $1
      end
      range_array = Array(lower.to_i..upper.to_i).map{ |num| "#{leading_zeros}#{num}" }
      processed_file = processed_file.sub(wildcard_sub,"--#{index}--")
      subs << {index: index, range_array: range_array}
      index += 1
    end
    ret = [processed_file]
    subs.each do |sub|
      range_array = sub[:range_array]
      index = sub[:index]
      new_ret = ret.map { |file| range_array.map { |num_str| file.sub("--#{index}--", num_str) } }.flatten
      ret = new_ret
    end
    ret
  end
end
