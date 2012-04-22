module SeedOMatic
  class Seeder

    attr_accessor :model_name, :items

    def initialize(data)
      @model_name = data[:model_name]
      @items = data[:items]
    end

    def import
      @items.each do |i|
        m = model_class.create(i)
      end
    end

  protected

    def model_class
      @model_name.is_a?(Class) ? @model_name : Kernel.const_get(@model_name)
    end

  end
end