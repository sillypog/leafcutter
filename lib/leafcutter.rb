class Leafcutter
  def initialize(json)
    @data = json
  end

  def validate
    status = { valid: true, errors: [] }

    # This is like run except we don't know which routes we want
    # Instead we want to explore all branches and report all the errors we find

    return validate_branch @data, :condition, status
  end

  def run(params)
    keys = @data.keys

    raise 'There should only be one top level key' if keys.length > 1
    raise 'Could not find top level key' if keys.length < 1

    key = keys[0]

    explore_branch @data, key, params
  end

  private

  def validate_branch data, node_type, status
    keys = data.kind_of?(Hash) ? data.keys : []

    unless keys.empty?
      if node_type == :condition && keys.length > 1
        status[:valid] = false
        status[:errors].push('multiple_conditions')
      elsif node_type == :option && keys.length < 2
        status[:valid] = false
        status[:errors].push('single_option')
      end

      keys.each do |key|
        next_node_type = node_type == :condition ? :option : :condition
        validate_branch data[key], next_node_type, status
      end
    else
      if data.kind_of?(Array)
        data.map!{ |d| d == '' ? nil : d }.compact! # Remove nils and empty strings
        if data.empty?
          status[:valid] = false
          status[:errors].push('empty_leaf')
        end
      else
        status[:valid] = false
        status[:errors].push('non_array_leaf')
      end
    end

    return status
  end

  def explore_branch data, key, params
    branch = params[key]

    value = data[key][branch]
    if value == nil
      raise "Error on #{key}. Expecting to explore #{data.keys} on branch '#{branch}'"
    end

    # If value is an array, return - we've found a leaf
    return value if value.kind_of?(Array)

    # Otherwise, recursively call using the value as the data for the next one
    keys = value.keys
    raise "Multiple keys at #{key}:#{branch.inspect}" if keys.length > 1
    raise "Could not find keys at #{key}:#{branch.inspect}" if keys.length < 1

    explore_branch value, keys[0], params
  end
end
