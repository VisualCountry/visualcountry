class ProfileSearchQuery
  def initialize(relation = User.all)
    @relation = relation.extending(Scopes)
  end

  def search(options = {})
    relation.
      by_name(options[:query]).
      by_location(options[:near]).
      by_interest_ids(options[:interests]).
      by_focus_ids(options[:focuses]).
      by_social_profiles(options.fetch(:social_profiles, [])).
      by_follower_count(
        options[:min_followers],
        options[:max_followers],
        options.fetch(:social_profiles, []),
      ).
      uniq
  end

  private

  attr_reader :relation

  module Scopes
    def by_name(name)
      if name.present?
        where('"users".name ILIKE ?', "%#{name}%")
      else
        all
      end
    end

    def by_interest_ids(ids)
      if ids.present?
        joins(:interests).where(interests: { id: ids.select(&:present?) })
      else
        all
      end
    end

    def by_focus_ids(ids)
      if ids.present?
        includes(:focuses).joins(:focuses).where(focuses: { id: ids.select(&:present?) })
      else
        all
      end
    end

    def by_social_profiles(social_profiles)
      column_names = social_profiles.map { |profile| "#{profile}_token" }
      query = column_names.map { |column_name| "#{column_name} IS NOT NULL" }.join(' AND ')

      if query
        where(query)
      else
        all
      end
    end

    def by_follower_count(min_followers, max_followers, social_profiles)
      if min_followers.present? || max_followers.present?
        min_followers = min_followers.to_i
        max_followers = if max_followers.blank?
          Float::INFINITY
        else
          max_followers.to_i
        end

        if social_profiles.empty?
          where(total_follower_count: min_followers..max_followers)
        else
          follower_count_columns_for_sql = social_profiles.map { |p| "cached_#{p}_follower_count" }.join(' + ')
          users = User.find_by_sql("SELECT *, (#{follower_count_columns_for_sql}) sum FROM users;")
          matched_users = users.reject { |user| user.sum.blank? }
          matched_users.select { |result| result.sum > min_followers && result.sum < max_followers }
        end
      else
        all
      end
    end

    def by_location(location)
      if location.present?
        near(location)
      else
        all
      end
    end
  end
end
