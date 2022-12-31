module ToFactory
  module Finders
    class Model
      def call(exclusions: [], klasses: nil)
        instances = []
        klasses ||= find_klasses(exclusions)

        klasses.each do |klass|
          if instance = get_active_record_instance(klass)
            instances << instance
          end
        end

        instances
      end

      private

      def find_klasses(exclusions)
        klasses = []
        models.each do |file|
          matching_lines(file) do |match|
            klass = rescuing_require(file, match)

            klasses << klass unless exclusions.include?(klass)
          end
        end

        klasses
      end

      def models
        Dir.glob("#{ToFactory.models}/**/*.rb")
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
        eval(match[1])
      rescue Exception => e
        warn "Failed to eval #{file}"
        warn e.message
      end

      def get_active_record_instance(klass)
        klass.first if klass && klass.ancestors.include?(ActiveRecord::Base)
      rescue StandardError => e
        warn "Failed to get record from #{klass} #{e.message.inspect}"
      end
    end
  end
end
