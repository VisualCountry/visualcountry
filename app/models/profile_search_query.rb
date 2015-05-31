class ProfileSearchQuery
  def initialize(options = {})
    @query = options[:query]
    @near = options[:near]
    @genders = remove_blanks(options[:gender])
    @ethnicity = options[:ethnicity]
    @min_age = options[:min_age]
    @max_age = options[:max_age]
    @interests = options.fetch(:interests, []).select(&:present?)
    @focuses = options.fetch(:focuses, []).select(&:present?)
    @social_profiles = options.fetch(:social_profiles, []).select(&:present?)
    @min_followers = options[:min_followers]
    @max_followers = options[:max_followers]
  end

  def search
    relation.
      by_query(query).
      by_location(near).
      by_genders(genders).
      by_ethnicity(ethnicity).
      by_minimum_age(min_age).
      by_maximum_age(max_age).
      by_interest_ids(interests).
      by_focus_ids(focuses).
      by_social_profiles(social_profiles).
      by_minimum_follower_count(min_followers, social_profiles).
      by_maximum_follower_count(max_followers, social_profiles).
      uniq
  end

  private

  attr_reader(
    :ethnicity,
    :focuses,
    :genders,
    :interests,
    :max_age,
    :max_followers,
    :min_age,
    :min_followers,
    :near,
    :query,
    :relation,
    :social_profiles,
  )

  def relation
    User.all.extending(Scopes)
  end

  module Scopes
    def by_query(query)
      if query.present?
        where(
          "name ILIKE :query OR bio ILIKE :query OR special_interests ILIKE :query",
          query: "%#{query}%",
        )
      else
        all
      end
    end

    def by_genders(genders)
      if genders.present?
        where(gender: genders.map { |g| User.genders[g] })
      else
        all
      end
    end

    def by_ethnicity(ethnicity)
      if ethnicity.present?
        where(ethnicity: User.ethnicities[ethnicity])
      else
        all
      end
    end

    def by_minimum_age(min_age)
      if min_age.present?
        where("birthday <= :deadline", deadline: min_age.to_i.years.ago)
      else
        all
      end
    end

    def by_maximum_age(max_age)
      if max_age.present?
        where("birthday >= :deadline", deadline: max_age.to_i.years.ago)
      else
        all
      end
    end

    def by_interest_ids(ids)
      if ids.present?
        joins(:interests).where(interests: { id: ids })
      else
        all
      end
    end

    def by_focus_ids(ids)
      if ids.present?
        includes(:focuses).joins(:focuses).where(focuses: { id: ids })
      else
        all
      end
    end

    def by_social_profiles(social_profiles)
      query = social_profiles.inject({}) do |attrs, profile|
        attrs.merge("#{profile}_token" => nil)
      end

      if query.present?
        where.not(query)
      else
        all
      end
    end

    def by_minimum_follower_count(count, social_profiles)
      if count.present?
        if social_profiles.empty?
          where("total_follower_count >= ?", count.to_i)
        else
          sum_expr = columns_for(social_profiles).join(" + ")
          where("#{sum_expr} >= ?", count)
        end
      else
        all
      end
    end

    def by_maximum_follower_count(count, social_profiles)
      if count.present?
        if social_profiles.empty?
          where("total_follower_count < ?", count.to_i)
        else
          sum_expr = columns_for(social_profiles).join(" + ")
          where("#{sum_expr} < ?", count)
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

    def columns_for(profiles)
      (profiles & User::SOCIAL_PLATFORMS).
        map { |platform| "cached_#{platform}_follower_count" }
    end
  end

  private

  def remove_blanks(array)
    return unless array

    array.delete_if(&:blank?)
  end
end
