module ToFactory
  class MissingActiveRecordInstance < Exception;end

  class Generator
    attr_accessor :model_class, :object_instance

    def initialize object=nil
      return unless object

      if object.is_a? ActiveRecord::Base
        @model_class = object.class.to_s
        @object_instance = object
      else
        @model_class = object.to_s
      end
    end

    def factory model
      out = "Factory #{model} do |#{model.to_s[0..0].downcase}|\n"
      out << yield if block_given?
      out << "end"
    end

    def attribute a
      raise MissingActiveRecordInstance unless object_instance
      value = object_instance.send a
      value = "\"#{value}\"" if value.is_a? String
      "  #{first_letter_of_class_name}.#{a} #{value}"
    end

    private
    def first_letter_of_class_name
      @model_class[0..0].downcase
    end
  end
end
