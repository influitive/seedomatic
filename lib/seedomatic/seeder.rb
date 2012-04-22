module SeedOMatic
  class Seeder

    attr_accessor :model_name, :items, :match_on

    def initialize(data)
      @model_name = data[:model_name]
      @items = data[:items]
      @match_on = [*data[:match_on]]
    end

    def import
      new_records = 0
      updated_records = 0

      items.each do |i|
        model = model_class.send(create_method, *create_args(i))

        if model.new_record?
          new_records += 1
        else
          updated_records += 1
        end

        model.attributes = i
        model.save!
      end

      { :count => items.length, :new => new_records, :updated => updated_records}
    end

  protected

    def create_method
      match_on.empty? ? 'new' : "find_or_initialize_by_#{match_on.join('_and_')}"
    end

    def create_args(item)
      match_on.map{|m| item[m] }
    end

    def model_class
      model_name.is_a?(Class) ? model_name : Kernel.const_get(model_name)
    end

  end
end