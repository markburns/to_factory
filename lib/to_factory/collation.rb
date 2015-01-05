module ToFactory
  AlreadyExists = Class.new ArgumentError

  class Collation
    def self.merge(a, b)
      c = new

      c.merge_without_collisions(a.with_indifferent_access, b.with_indifferent_access)
    end

    def merge_without_collisions(a,b)
      nested_detect_collisions!(a, b)

      a.deep_merge(b)
    end

    def nested_detect_collisions!(a,b)
      a.each do |a_klass, _|
        b.each do |b_klass, _|
          detect_collisions!(a[a_klass] || {}, b[b_klass] || {})
        end
      end
    end

    def detect_collisions!(a, b)
      overlapping = a.keys & b.keys
      raise_already_exists!(overlapping) if overlapping.any?
    end

    def raise_already_exists!(keys)
      raise ToFactory::AlreadyExists.new "an item for each of the following keys #{keys} already exists"
    end
  end
end
