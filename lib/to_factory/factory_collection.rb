module ToFactory
  class FactoryCollection
    include HashCollisionDetection

    attr_reader :items

    def initialize(items={})
      @items = items
    end

    def add(klass, name, definition)
      h = @items[klass] ||= {}
      raise_already_exists!(name) if h[name]

      h[name] = definition
    end

    def read_from_file_system(fs=file_system)
      extra_items = fs.read

      @items.each do |klass, items|
        detect_collisions!(extra_items[klass] || {}, items)
      end

      @items.merge! extra_items
    end

    def file_system
      @file_system ||= FileSystem.new
    end
  end
end
