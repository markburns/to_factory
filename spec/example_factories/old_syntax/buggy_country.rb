Factory.define(:madagascar, :parent => :country) do |o|
  o.country_fiscal_year_from_date("1995-12-31T23:00Z")
  o.country_fiscal_year_to_date("1996-12-30T23:00Z")
  o.country_id("MG")
  o.country_lending_terms("HC   ")
  o.country_official_name("Madagascar                                        ")
  o.country_project_controller_id("FO0768")
  o.country_short_name("Madagascar               ")
  o.country_struct_adj_flag("N")
  o.country_struct_adj_from_year(0)
  o.currency_code("MGF")
  o.region_id("PF   ")
end
Factory.define(:congo, :parent => :country) do |o|
  o.country_fiscal_year_from_date("1995-12-31T23:00Z")
  o.country_fiscal_year_to_date("1996-12-30T23:00Z")
  o.country_id("CG")
  o.country_lending_terms("Bl   ")
  o.country_official_name("Congo                                             ")
  o.country_project_controller_id("F00729F")
  o.country_short_name("Congo                    ")
  o.country_struct_adj_flag("N")
  o.country_struct_adj_from_year(0)
  o.currency_code("USD")
  o.region_id("PA   ")
end

Factory.define(:guatemala, :parent => :country) do |o|
  o.country_fiscal_year_from_date("1995-12-31T23:00Z")
  o.country_fiscal_year_to_date("1996-12-30T23:00Z")
  o.country_id("GT")
  o.country_lending_terms("O    ")
  o.country_official_name("Guatemala                                         ")
  o.country_project_controller_id("F63792")
  o.country_short_name("Guatemala                ")
  o.country_struct_adj_flag("N")
  o.country_struct_adj_from_year(0)
  o.currency_code("GTQ")
  o.region_id("PL   ")
end

Factory.define(:guatemala_with_projects, :parent => :guatemala) do |o|
  after(:create) do |c|
    c.projects << Factory.create(:guatemala_northern_project)
    c.projects << Factory.create(:guatemala_central_and_eastern_project)
  end
end

Factory.define(:country) do |o|
  o.country_fiscal_year_from_date("1996-01-01T00:00Z")
  o.country_fiscal_year_to_date("1996-12-31T00:00Z")
  o.country_id("AD")
  o.country_lending_terms("O    ")
  o.country_official_name("Andorra                                           ")
  o.country_project_controller_id("DUMMY")
  o.country_short_name("Andorra                  ")
  o.country_struct_adj_flag("N")
  o.country_struct_adj_from_year(0)
  o.currency_code("USD")
  o.region_id("OTH  ")
end
