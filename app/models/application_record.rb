class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

    # Strips HTML out of string properties from models on which this is called.
    # Should be called on before_save
    def sanitize_inputs
      attributes.each do |attr_name, attr_value|
        next unless attr_value.is_a? String
        self[attr_name] = strip_markup attr_value
      end
    end

    def strip_markup(str)
      marked_up = Sanitize.fragment str
      escape_sequences.each do |entity, ascii|
        marked_up = marked_up.gsub("&#{entity};", ascii)
      end
      marked_up
    end

    def escape_sequences
      {
        amp: '&',
        lt: '<',
        gt: '>'
      }
    end
end
