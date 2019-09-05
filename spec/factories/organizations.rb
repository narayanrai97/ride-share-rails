FactoryBot.define do
  factory :organization do
    name {'Duke'}
    street {'200 Front Street'}
    city {'Durham'}
    state {'NC'}
    zip {'27708'}
  end

  factory :organization2, class: Organization do
    name {'University of North Carolina'}
    street {'4000 Ashley Wade Ln'}
    city {'Chapel Hill'}
    state {'NC'}
    zip {'27514'}
  end
end
