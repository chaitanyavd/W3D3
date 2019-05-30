# == Schema Information
#
# Table name: shortened_urls
#
#  id        :bigint           not null, primary key
#  short_url :string           not null
#  long_url  :string           not null
#  user_id   :integer          not null
#
require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :long_url, presence: true, uniqueness: true
  validates :user_id, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
  primary_key: :id,
  foreign_key: :url_id,
  class_name: :Visit

  has_many :visitors,
  Proc.new { distinct }, #<<<
  through: :visits,
  source: :visitor

  def self.random_code
    code = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(short_url: code)
      code = SecureRandom.urlsafe_base64
    end
    code
  end

  def self.create!(user, long_url)
    ShortenedUrl.new(short_url: ShortenedUrl.random_code, user_id: user.id, long_url: long_url)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end
    
  def num_recent_uniques
    visits.select('user_id').distinct.where(['created_at > ?', 10.minutes.ago]).count
  end
end
