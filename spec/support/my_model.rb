class MyCategory

end

class MyThing

end

class MyModel
  attr_accessor :name, :new_record, :category, :things, :category_lookup, :things_lookup

  @@models = []

  def initialize(params = {})
    self.name = params['name']
    self.category = params['category']
    self.new_record = true
  end

  def self.reset
    @@models = []
  end

  def self.unscoped
    self
  end

  def self.create(params = {})
    @@models << m = new(params)
    m.new_record = false
    m
  end

  def attributes=(attr)
    attr = attr.with_indifferent_access
    self.name = attr['name']
    self.category = attr['category']
    self.things = attr['things']
    self.category_lookup = attr['category_lookup']
    self.things_lookup = attr['things_lookup']
  end

  def save!
    @@models << self
    new_record = false
    self
  end

  def save
    save!
    true
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
