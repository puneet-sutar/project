class Rule
  attr_reader :name
  attr_reader :error
  attr_reader :input
  attr_reader :on_input
  attr_reader :trigger
  def initialize(rule)
    @name=rule['name']
    @error=rule['error']
    @input=rule['input']
    @on_input=rule['on_input']
    @trigger=rule['trigger']
  end
  def execute
    puts $input
  end
end