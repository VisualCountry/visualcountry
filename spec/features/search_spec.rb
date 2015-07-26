require "rails_helper"

feature "Searching User profiles" do
  before do
    login_as(create(:admin))
  end

  feature "searching by query" do
    scenario "matches profiles by name" do
      alice = create(:profile, name: "Alice")
      bob = create(:profile, name: "Bob")

      visit profile_search_path
      save_and_open_page
      fill_in "test-query-input", with: "alice"
      click_button "Search"

      expect(page).to have_content alice.name
      expect(page).to have_no_content bob.name
    end

    scenario "matches profiles by bio" do
      alice = create(:profile, bio: "Antarctic explorer")
      bob = create(:profile, name: "Ramen enthusiast")

      visit profile_search_path
      fill_in "test-query-input", with: "Explorer"
      click_button "Search"

      expect(page).to have_content alice.name
      expect(page).to have_no_content bob.name
    end

    scenario "matches profiles by special interests" do
      alice = create(:profile, special_interests: "Writing Capybara tests")
      bob = create(:profile, special_interests: "Embroidery and arson")

      visit profile_search_path
      fill_in "test-query-input", with: "capybara"
      click_button "Search"

      expect(page).to have_content alice.name
      expect(page).to have_no_content bob.name
    end
  end

  feature "searching by location" do
    scenario "specifying a location only retrieves profiles near that location" do
      brooklyn_profile = create(:profile, city: "Brooklyn")
      la_profile = create(:profile, city: "Los Angeles")

      visit profile_search_path
      fill_in "test-location-input", with: "NYC"
      click_button "Search"

      expect(page).to have_content brooklyn_profile.name
      expect(page).to have_no_content la_profile.name
    end

    scenario "not specifying a location searches all profiles" do
      brooklyn_profile = create(:profile, city: "Brooklyn")
      la_profile = create(:profile, city: "Los Angeles")

      visit profile_search_path
      click_button "Search"

      expect(page).to have_content brooklyn_profile.name
      expect(page).to have_content la_profile.name
    end
  end

  feature "searching by gender" do
    scenario "specifying a gender only retrieves profiles with that gender" do
      male_profile = create(:profile, gender: "Male")
      female_profile = create(:profile, gender: "Female")

      visit profile_search_path
      check('Male')
      click_button "Search"

      expect(page).to have_content male_profile.name
      expect(page).to have_no_content female_profile.name
    end

    scenario "not specifying a gender searches all profiles" do
      male_profile = create(:profile, gender: "Male")
      female_profile = create(:profile, gender: "Female")

      visit profile_search_path
      click_button "Search"

      expect(page).to have_content male_profile.name
      expect(page).to have_content female_profile.name
    end
  end

  feature "searching by ethnicity" do
    scenario "specifying an ethnicity only retrieves profiles with that ethnicity" do
      hispanic_profile = create(:profile, ethnicity: "Hispanic or Latino")
      asian_profile = create(:profile, ethnicity: "Asian")

      visit profile_search_path
      within('#test-ethnicity-selection') do
        select("Hispanic or Latino")
      end
      click_button "Search"

      expect(page).to have_content hispanic_profile.name
      expect(page).to have_no_content asian_profile.name
    end

    scenario "not specifying an ethnicity searches all profiles" do
      hispanic_profile = create(:profile, ethnicity: "Hispanic or Latino")
      asian_profile = create(:profile, ethnicity: "Asian")

      visit profile_search_path
      click_button "Search"

      expect(page).to have_content hispanic_profile.name
      expect(page).to have_content asian_profile.name
    end
  end

  feature "searching by age" do
    scenario "specifying a minimum age only returns older profiles" do
      age_20_profile = create(:profile, birthday: 20.years.ago)
      age_30_profile = create(:profile, birthday: 30.years.ago)

      visit profile_search_path
      fill_in "test-min-age", with: 25
      click_button "Search"

      expect(page).to have_content age_30_profile.name
      expect(page).to have_no_content age_20_profile.name
    end

    scenario "specifying a maximum age only returns younger profiles" do
      age_20_profile = create(:profile, birthday: 20.years.ago)
      age_30_profile = create(:profile, birthday: 30.years.ago)

      visit profile_search_path
      fill_in "test-max-age", with: 25
      click_button "Search"

      expect(page).to have_content age_20_profile.name
      expect(page).to have_no_content age_30_profile.name
    end

    scenario "not specifying an age returns all profiles" do
      age_20_profile = create(:profile, birthday: 20.years.ago)
      age_30_profile = create(:profile, birthday: 30.years.ago)

      visit profile_search_path
      click_button "Search"

      expect(page).to have_content age_20_profile.name
      expect(page).to have_content age_30_profile.name
    end
  end

  feature "filtering by focus" do
    scenario "returns only those profiles with that focus" do
      photography = create(:focus, name: "Photography")
      cooking = create(:focus, name: "Cooking")
      photographer = create(:profile, focuses: [photography])
      cook = create(:profile, focuses: [cooking])
      disinterested = create(:profile)

      visit profile_search_path
      check "Photography"
      click_button "Search"

      expect(page).to have_content photographer.name
      expect(page).to have_no_content cook.name
      expect(page).to have_no_content disinterested.name
    end

    scenario "multiple focuses return profiles that satisfy any of them" do
      photography = create(:focus, name: "Photography")
      cooking = create(:focus, name: "Cooking")
      photographer = create(:profile, focuses: [photography])
      cook = create(:profile, focuses: [cooking])
      disinterested = create(:profile)

      visit profile_search_path
      check "Photography"
      check "Cooking"
      click_button "Search"

      expect(page).to have_content photographer.name
      expect(page).to have_content cook.name
      expect(page).to have_no_content disinterested.name
    end
  end

  feature "filtering by interest" do
    scenario "returns only those profiles with that interest" do
      photography = create(:interest, name: "Photographer")
      directing = create(:interest, name: "Director")
      photographer = create(:profile, interests: [photography])
      director = create(:profile, interests: [directing])
      disinterested = create(:profile)

      visit profile_search_path
      check "Photographer"
      click_button "Search"

      expect(page).to have_content photographer.name
      expect(page).to have_no_content director.name
      expect(page).to have_no_content disinterested.name
    end

    scenario "multiple interests return profiles that satisfy any of them" do
      photography = create(:interest, name: "Photographer")
      directing = create(:interest, name: "Director")
      photographer = create(:profile, interests: [photography])
      director = create(:profile, interests: [directing])
      disinterested = create(:profile)

      visit profile_search_path
      check "Photographer"
      check "Director"
      click_button "Search"

      expect(page).to have_content photographer.name
      expect(page).to have_content director.name
      expect(page).to have_no_content disinterested.name
    end
  end

  feature "filtering by followers and social media profiles" do
    scenario "returns profiles between the min and max numbers of followers" do
      unpopular_profile = create(
        :profile,
        :with_twitter,
        cached_twitter_follower_count: 10,
      )
      target_profile = create(
        :profile,
        :with_twitter,
        cached_twitter_follower_count: 100,
      )
      popular_profile = create(
        :profile,
        :with_twitter,
        cached_twitter_follower_count: 1000,
      )

      visit profile_search_path
      fill_in "Min followers", with: 50
      fill_in "Max followers", with: 500
      click_button "Search"

      expect(page).to have_content target_profile.name
      expect(page).to have_no_content unpopular_profile.name
      expect(page).to have_no_content popular_profile.name
    end

    context "when a specific social media platform is selected" do
      scenario "only profiles with the right number of followers from that platform are returned" do
        twitter_profile = create(
          :profile,
          :with_twitter,
          cached_twitter_follower_count: 100,
        )
        target_profile = create(
          :profile,
          :with_twitter,
          :with_instagram,
          cached_twitter_follower_count: 10,
          cached_instagram_follower_count: 100,
        )
        popular_profile = create(
          :profile,
          :with_instagram,
          cached_instagram_follower_count: 1000,
        )

        visit profile_search_path
        fill_in "Min followers", with: 50
        fill_in "Max followers", with: 500
        check "instagram"
        click_button "Search"

        expect(page).to have_content target_profile.name
        expect(page).to have_no_content twitter_profile.name
        expect(page).to have_no_content popular_profile.name
      end
    end

    context "when no min/max are selected" do
      scenario "only profiles on the selected social media platforms are returned" do
        twitter_profile = create(
          :profile,
          :with_twitter,
          cached_twitter_follower_count: 100,
        )
        instagram_profile = create(
          :profile,
          :with_instagram,
          cached_instagram_follower_count: 100,
        )

        visit profile_search_path
        check "instagram"
        click_button "Search"

        expect(page).to have_content instagram_profile.name
        expect(page).to have_no_content twitter_profile.name
      end

      context "when only certain platforms are selected" do
        scenario "allows omitting the minimum" do
          unpopular_profile = create(
            :profile,
            :with_twitter,
            cached_twitter_follower_count: 10,
          )
          middle_profile = create(
            :profile,
            :with_twitter,
            cached_twitter_follower_count: 100,
          )
          popular_profile = create(
            :profile,
            :with_twitter,
            cached_twitter_follower_count: 1000,
          )

          visit profile_search_path
          fill_in "Max followers", with: 500
          check "twitter"
          click_button "Search"

          expect(page).to have_content middle_profile.name
          expect(page).to have_content unpopular_profile.name
          expect(page).to have_no_content popular_profile.name
        end

        scenario "allows omitting the maximum" do
          unpopular_profile = create(
            :profile,
            :with_twitter,
            cached_twitter_follower_count: 10,
          )
          middle_profile = create(
            :profile,
            :with_twitter,
            cached_twitter_follower_count: 100,
          )
          popular_profile = create(
            :profile,
            :with_twitter,
            cached_twitter_follower_count: 1000,
          )

          visit profile_search_path
          fill_in "Min followers", with: 50
          check "twitter"
          click_button "Search"

          expect(page).to have_content middle_profile.name
          expect(page).to have_content popular_profile.name
          expect(page).to have_no_content unpopular_profile.name
        end
      end
    end
  end

  feature "searching across multiple features" do
    scenario "returns only the intersection of focuses and interests" do
      cooking = create(:focus, name: "Cooking")
      technology = create(:focus, name: "Technology")
      directing = create(:interest, name: "Director")
      photography = create(:interest, name: "Photographer")
      cooking_director = create(:profile, interests: [directing], focuses: [cooking])
      tech_photographer = create(:profile, interests: [photography], focuses: [technology])
      cooking_photographer = create(:profile, interests: [photography], focuses: [cooking])

      visit profile_search_path
      check "Cooking"
      check "Photographer"
      click_button "Search"

      expect(page).to have_content cooking_photographer.name
      expect(page).to have_no_content tech_photographer.name
      expect(page).to have_no_content cooking_director.name
    end

    scenario "returns only the intersection of followers and interests" do
      directing = create(:interest, name: "Director")
      directing_twitter_profile = create(
        :profile,
        :with_twitter,
        interests: [directing],
        cached_twitter_follower_count: 100,
      )
      non_directing_target_profile = create(
        :profile,
        :with_twitter,
        :with_instagram,
        cached_twitter_follower_count: 10,
        cached_instagram_follower_count: 100,
      )
      target_profile = create(
        :profile,
        :with_twitter,
        :with_instagram,
        interests: [directing],
        cached_twitter_follower_count: 10,
        cached_instagram_follower_count: 100,
      )
      directing_popular_profile = create(
        :profile,
        :with_instagram,
        interests: [directing],
        cached_instagram_follower_count: 1000,
      )

      visit profile_search_path
      fill_in "Min followers", with: 50
      fill_in "Max followers", with: 500
      check "instagram"
      check "twitter"
      check "Director"
      click_button "Search"

      expect(page).to have_content target_profile.name
      expect(page).to have_no_content directing_twitter_profile.name
      expect(page).to have_no_content non_directing_target_profile.name
      expect(page).to have_no_content directing_popular_profile.name
    end
  end
end
