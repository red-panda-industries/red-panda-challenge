class MichelleObamaChallengeEntry < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :date, uniqueness: { scope: :user_id }
end
