module ToFactory
  AlreadyExists = Class.new ArgumentError

  class FactoryCollection
    include HashCollisions
    attr_reader :items

    def initialize(items)
      raise ArgumentError.new "Expected hash" unless items.is_a?(Hash)
      @items = items
    end

    def add(key, value)
      raise_already_exists!(key) if @items[key]

      @items[key]=value
    end

    def read(file_system=FileSystem.new)
      extra_items = file_system.read
      detect_collisions!(extra_items, @items)

      @items.merge! extra_items
    end

    private



  end
end
