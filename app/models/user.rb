class User < ActiveRecord::Base
  attr_reader :focus_tokens

  SOCIAL_PROFILES = %w(vine twitter instagram facebook pinterest)
  FOLLOWER_COUNT_METHODS = SOCIAL_PROFILES.map { |p| "#{p}_follower_count"}

  has_and_belongs_to_many :interests
  has_and_belongs_to_many :focuses
  has_and_belongs_to_many :clients

  has_many :press

  accepts_nested_attributes_for :clients, allow_destroy: true
  accepts_nested_attributes_for :press, allow_destroy: true

  has_attached_file :picture
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :instagram, :twitter, :pinterest]

  delegate :media, :follower_count, to: :instagram, prefix: true, allow_nil: true
  delegate :media, :follower_count, to: :vine, prefix: true, allow_nil: true
  delegate :follower_count, to: :twitter, prefix: true, allow_nil: true
  delegate :follower_count, to: :facebook, prefix: true, allow_nil: true

  scope :by_name, -> (name) { User.where('"users".name ILIKE ?', "%#{name}%") if name.present? }

  scope :by_interest_ids, -> (ids) do
    joins(:interests).where(interests: {id: nil_if_blank(ids)}) if ids.present?
  end

  scope :by_social_profiles, -> (social_profiles) do
    column_names = social_profiles.map { |profile| "#{profile}_token" }
    query = column_names.map { |column_name| "#{column_name} IS NOT NULL" }.join(' AND ')

    where(query) if query
  end

  def self.search(options = {})
    all.
      by_name(options[:name]).
      by_interest_ids(nil_if_blank(options[:interests])).
      by_social_profiles(nil_if_blank(options[:social_profiles])).
      uniq
  end

  def total_social_count
    FOLLOWER_COUNT_METHODS.inject(0) do |sum, method|
      count = send(method)
      count == nil ? sum += 0 : sum += count
    end
  end

  def instagram
    @instagram ||= InstagramService.from_user(self)
  end

  def vine
    @vine ||= VineService.from_user(self)
  end

  def twitter
    @twitter ||= TwitterService.from_user(self)
  end

  def facebook
    @facebook ||= FacebookService.from_user(self)
  end

  def pinterest_follower_count
    #TODO
  end

  private

  def self.nil_if_blank(array)
    array.reject(&:empty?)
  end
end
