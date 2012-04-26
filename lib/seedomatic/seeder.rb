module SeedOMatic
  class Seeder

    attr_accessor :model_name, :items, :match_on, :seed_mode

    def initialize(data)
      @model_name = data[:model_name]
      @items = data[:items]
      @match_on = [*data[:match_on]]
      @seed_mode = data[:seed_mode] || "always"
    end

    def import
      new_records = 0
      updated_records = 0

      items.each do |attrs|
        model = model_class.send(create_method, *create_args(attrs))

        if model.new_record?
          new_records += 1
        else
          updated_records += 1
        end

        if model.new_record? || seed_mode == 'always'
          model.attributes = process_lookups(attrs)
          model.save!
        end
      end

      { :count => items.length, :new => new_records, :updated => updated_records}
    end

  protected

    def process_lookups(attrs)
      attrs.select{|k| k.ends_with? "_lookup"}.each do |key, value|
        association = key.gsub("_lookup", "")
        lookup_class = model_class.reflect_on_association(association).klass

        attrs[association] = lookup_class.where(value).first
      end
      attrs
    end

    def create_method
      match_on.empty? ? 'new' : "find_or_initialize_by_#{match_on.join('_and_')}"
    end

    def create_args(item)
      match_on.map{|m| item[m] }
    end

    def model_class
      return model_name if model_name.is_a? Class
      model_name.to_s.classify.constantize
    end

  end
end