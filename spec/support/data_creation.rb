module ToFactory::DataCreation
  def create_all!
    create_user!
    create_admin!
  end

  def create_project!
    ToFactory::Project.create(name: "My Project", objective: "easy testing", some_id: 9)
  end

  def birthday
    Time.find_zone("UTC").parse("2014-07-08T15:30Z")
  end

  def create_user!
    ToFactory::User.create(
      name: "Jeff",
      email: "test@example.com",
      some_attributes: { a: 1 },
      some_id: 8,
      birthday: birthday
    )
  end

  def create_admin!
    ToFactory::User.create(
      name: "Admin",
      email: "admin@example.com",
      some_attributes: { a: 1 },
      some_id: 9,
      birthday: birthday
    )
  end
end
