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
  Doctor
  Professor 
  Lil
  Big
  Mega
  Ultra
  Hyper
  Captain
  Major
  Baby
  Da
  The
  Its
  TheReal
  Real
  Fake
)

animals = %w(
  Monkey
  Panda
  Tiger
  Lion
  Bear
  Elephant
  Giraffe
  Zebra
  Kangaroo
  Koala
  Platypus
  Wallaby
  Wombat
  Dingo
  TasmanianDevil
  Crocodile
  Alligator
  Snake
  Lizard
  Gecko
  Chameleon
  Iguana
  Turtle
  Tortoise
  Frog
  Fox
  Wolf
  Dog
  Cat
  Rabbit
  Hamster
  GuineaPig
  Rat
  Mouse
  Gerbil
  Ferret
)

names = %w(
  Kwame
  Mark
  Aisha
  Jamal
  Eunice
  Gabrielle
  Thanayi
  Sharon
  Nomalungelo
  Paul
  Wesley
  Beatrice
  Charlie
  Fran
  Rebecca
)

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "#{username_prefixes.sample}#{animals.sample if rand < 0.4}#{names.sample}#{n}" }
    discord_id { rand(100_000_000_000_000_000..999_999_999_999_999_999) }
    count { 0 }
    created_at { Time.now }
    updated_at { Time.now }
  end

  factory :michelle_obama_challenge_entry do
    user
    date { Date.today }
  end
end
