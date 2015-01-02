module HashCollisions
  def detect_collisions!(a, b)
    overlapping = a.keys & b.keys
    raise_already_exists!(overlapping) if overlapping.any?
  end

  def raise_already_exists!(keys)
    raise ToFactory::AlreadyExists.new "an item for each of the following keys #{keys} already exists"
  end
end
