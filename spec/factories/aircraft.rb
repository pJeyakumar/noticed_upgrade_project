FactoryBot.define do
  factory :aircraft do
    make { "LM" }
    model { "C-17" }
    engine { "single" }
  end
end
