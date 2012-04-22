class MyModel
  attr_accessor :name

  def initialize(params)
    self.name = params['name']
  end

  def create(params)
    MyModel.new(params)
  end

  def save
    # Just here for stubbing purposes.
  end
end