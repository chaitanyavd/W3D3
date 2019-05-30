# == Schema Information
#
# Table name: visits
#
#  id         :bigint           not null, primary key
#  url_id     :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Visit < ApplicationRecord

  validates :user_id, presence: true
  validates :url_id, presence: true


  def self.record_visit!(user, shortened_url)
    Visit.new(user_id: user.id, url_id: shortened_url.id)
  end


  belongs_to :visitor,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :url,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :ShortenedUrl


end
