module ToFactory
  module Finders
    class Model
      def call(exclusions=[])
        instances = []

        each_klass(exclusions) do |klass|
          if instance = get_active_record_instance(klass)
            instances << instance
          end
        end

        instances
      end

      private

      def each_klass(exclusions)
        each_model do |file|
          matching_lines(file) do |match|
            klass = rescuing_require file, match
            break if exclusions.include?(klass)

            break if yield klass
          end
        end
      end


      def each_model
        Dir.glob("#{ToFactory.models}/**/*.rb").each do |file|
          yield file
        end
      end

      def matching_lines(file)
        File.readlines(file).each do |l|
          if match = l.match(/class (.*) ?</)
            yield match
          end
        end
      end

      def rescuing_require(file, match)
        require file
        klass = eval(match[1])
        klass

      rescue Exception => e
        warn "Failed to eval #{file}"
        warn e.message
      end

      def get_active_record_instance(klass)
        if klass && klass.ancestors.include?(ActiveRecord::Base)
          begin
            klass.first
          rescue
            klass.find(:first)
          end
        end
      rescue Exception => e
        warn "Failed to get record from #{klass} #{e.message}"
      end
    end
  end
end
