class MigrateUserToProfile
  ATTR_MAPPINGS = {
    :user_id                    => :id,
    :created_at                 => :created_at,
    :updated_at                 => :updated_at,
    :picture                    => :picture,
    :username                   => :username,
    :name                       => :name,
    :city                       => :city,
    :bio                        => :bio,
    :website                    => :website,
    :instagram_follower_count   => :cached_instagram_follower_count,
    :twitter_follower_count     => :cached_twitter_follower_count,
    :vine_follower_count        => :cached_vine_follower_count,
    :facebook_follower_count    => :cached_facebook_follower_count,
    :pinterest_follower_count   => :cached_pinterest_follower_count,
    :total_follower_count       => :total_follower_count,
    :latitude                   => :latitude,
    :longitude                  => :longitude,
    :birthday                   => :birthday,
    :special_interests          => :special_interests,
  }

  def initialize(user)
    @user = user
  end

  def self.perform(user_id)
    user = User.find(user_id)
    new(user).perform
  end

  def perform
    find_or_create_profile.tap do
      copy_user_attributes_to_profile
      copy_user_clients_to_profile
      copy_user_ethnicity_to_profile
      copy_user_focuses_to_profile
      copy_user_gender_to_profile
      copy_user_interests_to_profile
      copy_user_press_to_profile
      copy_user_list_memberships_to_profile
      copy_organization_memberships_to_profile
    end
  end

  private

  attr_reader :profile, :user

  def find_or_create_profile
    @profile = find_profile || create_profile
  end

  def copy_user_attributes_to_profile
    profile.update(profile_data) #TODO: Skip callbacks
  end

  def copy_user_clients_to_profile
    puts "Creating clients for #{profile.name}"
    profile.clients = user.clients
  end

  def copy_user_ethnicity_to_profile
    puts "Setting ethnicity for #{profile.name}"
    profile.ethnicity = user.ethnicity
  end

  def copy_user_focuses_to_profile
    puts "Creating focuses for #{profile.name}"
    profile.focuses = user.focuses
  end

  def copy_user_gender_to_profile
    puts "Setting gender for #{profile.name}"
    profile.gender = user.gender
  end

  def copy_user_interests_to_profile
    puts "Creating interests for #{profile.name}"
    profile.interests = user.interests
  end

  def copy_user_press_to_profile
    puts "Creating press for #{profile.name}"
    profile.press = user.press
  end

  def copy_user_list_memberships_to_profile
    puts "Creating list memberships for #{profile.name}"
    user.list_memberships.map do |membership|
      membership.update(profile: profile)
    end
  end

  def copy_organization_memberships_to_profile
    puts "Creating organization memberships for #{profile.name}"
    user.organization_memberships.map do |membership|
      membership.update(profile: profile)
    end
  end

  def profile_data
    ATTR_MAPPINGS.each_with_object({}) do |(profile_attr, user_attr), hash|
      hash[profile_attr] = user.send(user_attr)
    end
  end

  def find_profile
    Profile.find_by(user_id: user.id).tap do |profile|
      puts "Found profile for #{profile.name}" if profile
    end
  end

  def create_profile
    Profile.create(id: user.id, user_id: user.id).tap do |profile|
      puts "Creating profile for #{user.name}" if profile
    end
  end
end
