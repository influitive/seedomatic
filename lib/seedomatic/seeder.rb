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
        model = model_class.unscoped.send(create_method, create_args(attrs))

        if model.new_record?
          new_records += 1
        else
          updated_records += 1
        end

        if model.new_record? || seed_mode == 'always'
          clean_up_associations(model, attrs)
          model.attributes = process_lookups(attrs)
          if !model.save
            raise "Unable to save model: #{model} - #{model.errors.full_messages.join(", ")}"
          end
        end
      end

      { :count => items.length, :new => new_records, :updated => updated_records}
    end

  protected

    def clean_up_associations(model, attrs)
      attrs.select{|a| a.ends_with?('attributes')}.each do |key, value|
        association = key.gsub("_attributes", "").to_sym

        if model_class.reflect_on_association(association).collection?
          model.send(association).destroy_all
        end
      end
    end

    def process_lookups(attrs)
      attrs.select{|k| k.ends_with? "_lookup"}.each do |key, value|
        attrs.delete(key)

        association = key.gsub("_lookup", "").to_sym
        reflection = model_class.reflect_on_association(association)
        lookup_class = reflection.klass
        association_type = reflection.macro

        if association_type == :has_many
          attrs[association] = []
          value.each do |v|
            attrs[association] << lookup_class.where(v).first
          end
        else
          attrs[association] = lookup_class.where(value).first
        end
      end
      attrs
    end

    def create_method
      match_on.empty? ? 'new' : "find_or_initialize_by"
    end

    def create_args(item)
      match_on.inject({}) do |result,m|
        result[m] = item[m]
        result
      end
    end

    def model_class
      return model_name if model_name.is_a? Class
      model_name.to_s.classify.constantize
    end

  end
end
