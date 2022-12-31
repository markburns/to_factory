module ToFactory
  AlreadyExists = Class.new ArgumentError

  class Collation
    def self.organize(a, b)
      new(a, b).organize
    end

    def self.representations_from(a, b)
      new(a, b).representations
    end

    def initialize(a, b)
      @a = a
      @b = b
    end

    def organize
      representations.group_by { |i| i.klass.name.underscore }.each_with_object({}) do |(klass_name, r), o|
        o[klass_name] = r.sort_by { |r| [r.hierarchy_order, r.name] }
      end
    end

    def representations
      detect_collisions!(@a, @b)

      inference = KlassInference.new(merged)

      merged.each do |r|
        klass, order = inference.infer(r.name)
        r.klass = klass
        r.hierarchy_order = order
      end

      merged
    end

    def detect_collisions!(a, b)
      collisions = []
      a.each do |x|
        b.each do |y|
          collisions << x.name if x.name == y.name
        end
      end

      raise_already_exists!(collisions) if collisions.any?
    end

    private

    def merged
      @merged ||= @a + @b
    end

    def raise_already_exists!(keys)
      raise ToFactory::AlreadyExists, "an item for each of the following keys #{keys.inspect} already exists"
    end
  end
end
