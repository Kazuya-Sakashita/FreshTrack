FactoryBot.define do
  factory :job_schedule do
    user { nil }
    cron { "MyString" }
  end
end
