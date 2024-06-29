username_prefixes = %w(
  Red
  Blue
  Green
  North
  East
  South
  West
  Super
  Radical
)

names = %w(
  Kwame
  Mark
  Aisha
  Juan
  Jamal
  Eunice
  Maria
)

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "#{username_prefixes.sample}#{names.sample}#{n}" }
    discord_id { rand(100_000_000_000_000_000..999_999_999_999_999_999) }
    count { 0 }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
