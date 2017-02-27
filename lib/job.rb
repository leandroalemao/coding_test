class Job
  attr_reader :name, :dependency

  def initialize(name, dependency=nil)
    @name = name
    @dependency = dependency
    raise ArgumentError, "Jobs can't depend on themselves" if name == dependency
  end
end
