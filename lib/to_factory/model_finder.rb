module ToFactory
  class ModelFinder
    def initialize(path="./app/models")
      @path = File.expand_path(path)
    end

    def all
      instances = []

      Dir.glob("#{@path}/**/*.rb").each do |file|
        File.readlines(file).each do |f|
          if match = f.match(/class (.*) ?</)
            klass = rescuing_require file, match
            instance = get_active_record_instance(klass)
            instances << instance if instance
            break
          end
        end
      end

      instances
    end

    private

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
