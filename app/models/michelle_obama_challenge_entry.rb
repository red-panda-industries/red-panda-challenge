class MichelleObamaChallengeEntry < ActiveRecord::Base
  has_one :user

  validates :user, presence: true
  validates :date, uniqueness: { scope: :user_id }
end
