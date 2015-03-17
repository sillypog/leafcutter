class Leafcutter
  def initialize(json)
    @data = json
  end

  def run(params)
    keys = @data.keys

    raise 'There should only be one top level key' if keys.length > 1
    raise 'Could not find top level key' if keys.length < 1

    key = keys[0]

    explore_branch @data, key, params
  end

  private

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
