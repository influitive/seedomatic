class MyModel
  attr_accessor :name, :new_record

  @@models = []

  def initialize(params = {})
    self.name = params['name']
    self.new_record = true
  end

  def self.create(params = {})
    @@models << m = new(params)
    m.new_record = false
    m
  end

  def attributes=(attr)
    self.name = attr['name']
  end

  def save!
    @@models << self
    new_record = false
    self
  end

  def new_record?
    @new_record
  end

  def self.[] (index)
    @@models[index]
  end

  def self.models
    @@models
  end

end