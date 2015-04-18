require "rails_helper"

feature "Searching User profiles" do
  before do
    login_as(create(:admin))
  end

  feature "searching by query" do
    scenario "matches users by name" do
      alice = create(:user, name: "Alice")
      bob = create(:user, name: "Bob")

      visit profile_search_path
      fill_in "Query", with: "alice"
      click_button "Search"

      expect(page).to have_content alice.name
      expect(page).to have_no_content bob.name
    end

    scenario "matches users by bio" do
      alice = create(:user, bio: "Antarctic explorer")
      bob = create(:user, name: "Ramen enthusiast")

      visit profile_search_path
      fill_in "Query", with: "Explorer"
      click_button "Search"

      expect(page).to have_content alice.name
      expect(page).to have_no_content bob.name
    end

    scenario "matches users by special interests" do
      alice = create(:user, special_interests: "Writing Capybara tests")
      bob = create(:user, special_interests: "Embroidery and arson")

      visit profile_search_path
      fill_in "Query", with: "capybara"
      click_button "Search"

      expect(page).to have_content alice.name
      expect(page).to have_no_content bob.name
    end
  end

  feature "searching by location" do
    scenario "specifying a location only retrieves users near that location" do
      brooklyn_user = create(:user, city: "Brooklyn")
      la_user = create(:user, city: "Los Angeles")

      visit profile_search_path
      fill_in "Near", with: "NYC"
      click_button "Search"

      expect(page).to have_content brooklyn_user.name
      expect(page).to have_no_content la_user.name
    end

    scenario "not specifying a location searches all users" do
      brooklyn_user = create(:user, city: "Brooklyn")
      la_user = create(:user, city: "Los Angeles")

      visit profile_search_path
      click_button "Search"

      expect(page).to have_content brooklyn_user.name
      expect(page).to have_content la_user.name
    end
  end

  feature "searching by gender" do
    scenario "specifying a gender only retrieves users with that gender" do
      male_user = create(:user, gender: "Male")
      female_user = create(:user, gender: "Female")

      visit profile_search_path
      within('.gender-selection') do
        select("Male")
      end
      click_button "Search"

      expect(page).to have_content male_user.name
      expect(page).to have_no_content female_user.name
    end

    scenario "not specifying a gender searches all users" do
      male_user = create(:user, gender: "Male")
      female_user = create(:user, gender: "Female")

      visit profile_search_path
      click_button "Search"

      expect(page).to have_content male_user.name
      expect(page).to have_content female_user.name
    end
  end

  feature "searching by ethnicity" do
    scenario "specifying an ethnicity only retrieves users with that ethnicity" do
      hispanic_user = create(:user, ethnicity: "Hispanic or Latino")
      asian_user = create(:user, ethnicity: "Asian")

      visit profile_search_path
      within('.ethnicity-selection') do
        select("Hispanic or Latino")
      end
      click_button "Search"

      expect(page).to have_content hispanic_user.name
      expect(page).to have_no_content asian_user.name
    end

    scenario "not specifying an ethnicity searches all users" do
      hispanic_user = create(:user, ethnicity: "Hispanic or Latino")
      asian_user = create(:user, ethnicity: "Asian")

      visit profile_search_path
      click_button "Search"

      expect(page).to have_content hispanic_user.name
      expect(page).to have_content asian_user.name
    end
  end

  feature "searching by age" do
    scenario "specifying a minimum age only returns older users" do
      age_20_user = create(:user, birthday: 20.years.ago)
      age_30_user = create(:user, birthday: 30.years.ago)

      visit profile_search_path
      fill_in "Min age", with: 25
      click_button "Search"

      expect(page).to have_content age_30_user.name
      expect(page).to have_no_content age_20_user.name
    end

    scenario "specifying a maximum age only returns younger users" do
      age_20_user = create(:user, birthday: 20.years.ago)
      age_30_user = create(:user, birthday: 30.years.ago)

      visit profile_search_path
      fill_in "Max age", with: 25
      click_button "Search"

      expect(page).to have_content age_20_user.name
      expect(page).to have_no_content age_30_user.name
    end

    scenario "not specifying an age returns all users" do
      age_20_user = create(:user, birthday: 20.years.ago)
      age_30_user = create(:user, birthday: 30.years.ago)

      visit profile_search_path
      click_button "Search"

      expect(page).to have_content age_20_user.name
      expect(page).to have_content age_30_user.name
    end
  end

  feature "filtering by focus" do
    scenario "returns only those users with that focus" do
      photography = create(:focus, name: "Photography")
      cooking = create(:focus, name: "Cooking")
      photographer = create(:user, focuses: [photography])
      cook = create(:user, focuses: [cooking])
      disinterested = create(:user)

      visit profile_search_path
      check "Photography"
      click_button "Search"

      expect(page).to have_content photographer.name
      expect(page).to have_no_content cook.name
      expect(page).to have_no_content disinterested.name
    end

    scenario "multiple focuses return users that satisfy any of them" do
      photography = create(:focus, name: "Photography")
      cooking = create(:focus, name: "Cooking")
      photographer = create(:user, focuses: [photography])
      cook = create(:user, focuses: [cooking])
      disinterested = create(:user)

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
    scenario "returns only those users with that interest" do
      photography = create(:interest, name: "Photographer")
      directing = create(:interest, name: "Director")
      photographer = create(:user, interests: [photography])
      director = create(:user, interests: [directing])
      disinterested = create(:user)

      visit profile_search_path
      check "Photographer"
      click_button "Search"

      expect(page).to have_content photographer.name
      expect(page).to have_no_content director.name
      expect(page).to have_no_content disinterested.name
    end

    scenario "multiple interests return users that satisfy any of them" do
      photography = create(:interest, name: "Photographer")
      directing = create(:interest, name: "Director")
      photographer = create(:user, interests: [photography])
      director = create(:user, interests: [directing])
      disinterested = create(:user)

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
    scenario "returns users between the min and max numbers of followers" do
      unpopular_user = create(
        :user,
        :with_twitter,
        cached_twitter_follower_count: 10,
      )
      target_user = create(
        :user,
        :with_twitter,
        cached_twitter_follower_count: 100,
      )
      popular_user = create(
        :user,
        :with_twitter,
        cached_twitter_follower_count: 1000,
      )

      visit profile_search_path
      fill_in "Min followers", with: 50
      fill_in "Max followers", with: 500
      click_button "Search"

      expect(page).to have_content target_user.name
      expect(page).to have_no_content unpopular_user.name
      expect(page).to have_no_content popular_user.name
    end

    context "when a specific social media platform is selected" do
      scenario "only users with the right number of followers from that platform are returned" do
        twitter_user = create(
          :user,
          :with_twitter,
          cached_twitter_follower_count: 100,
        )
        target_user = create(
          :user,
          :with_twitter,
          :with_instagram,
          cached_twitter_follower_count: 10,
          cached_instagram_follower_count: 100,
        )
        popular_user = create(
          :user,
          :with_instagram,
          cached_instagram_follower_count: 1000,
        )

        visit profile_search_path
        fill_in "Min followers", with: 50
        fill_in "Max followers", with: 500
        check "instagram"
        click_button "Search"

        expect(page).to have_content target_user.name
        expect(page).to have_no_content twitter_user.name
        expect(page).to have_no_content popular_user.name
      end
    end

    context "when no min/max are selected" do
      scenario "only users on the selected social media platforms are returned" do
        twitter_user = create(
          :user,
          :with_twitter,
          cached_twitter_follower_count: 100,
        )
        instagram_user = create(
          :user,
          :with_instagram,
          cached_instagram_follower_count: 100,
        )

        visit profile_search_path
        check "instagram"
        click_button "Search"

        expect(page).to have_content instagram_user.name
        expect(page).to have_no_content twitter_user.name
      end

      context "when only certain platforms are selected" do
        scenario "allows omitting the minimum" do
          unpopular_user = create(
            :user,
            :with_twitter,
            cached_twitter_follower_count: 10,
          )
          middle_user = create(
            :user,
            :with_twitter,
            cached_twitter_follower_count: 100,
          )
          popular_user = create(
            :user,
            :with_twitter,
            cached_twitter_follower_count: 1000,
          )

          visit profile_search_path
          fill_in "Max followers", with: 500
          check "twitter"
          click_button "Search"

          expect(page).to have_content middle_user.name
          expect(page).to have_content unpopular_user.name
          expect(page).to have_no_content popular_user.name
        end

        scenario "allows omitting the maximum" do
          unpopular_user = create(
            :user,
            :with_twitter,
            cached_twitter_follower_count: 10,
          )
          middle_user = create(
            :user,
            :with_twitter,
            cached_twitter_follower_count: 100,
          )
          popular_user = create(
            :user,
            :with_twitter,
            cached_twitter_follower_count: 1000,
          )

          visit profile_search_path
          fill_in "Min followers", with: 50
          check "twitter"
          click_button "Search"

          expect(page).to have_content middle_user.name
          expect(page).to have_content popular_user.name
          expect(page).to have_no_content unpopular_user.name
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
      cooking_director = create(:user, interests: [directing], focuses: [cooking])
      tech_photographer = create(:user, interests: [photography], focuses: [technology])
      cooking_photographer = create(:user, interests: [photography], focuses: [cooking])

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
      directing_twitter_user = create(
        :user,
        :with_twitter,
        interests: [directing],
        cached_twitter_follower_count: 100,
      )
      non_directing_target_user = create(
        :user,
        :with_twitter,
        :with_instagram,
        cached_twitter_follower_count: 10,
        cached_instagram_follower_count: 100,
      )
      target_user = create(
        :user,
        :with_twitter,
        :with_instagram,
        interests: [directing],
        cached_twitter_follower_count: 10,
        cached_instagram_follower_count: 100,
      )
      directing_popular_user = create(
        :user,
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

      expect(page).to have_content target_user.name
      expect(page).to have_no_content directing_twitter_user.name
      expect(page).to have_no_content non_directing_target_user.name
      expect(page).to have_no_content directing_popular_user.name
    end
  end
end
