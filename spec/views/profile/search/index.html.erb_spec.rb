require "rails_helper"

describe "profile/search/index.html.erb" do
  it "displays truncated thousands" do
    assign(
      :profiles,
      [
        build(
          :user,
          cached_twitter_follower_count: 45_678,
          cached_vine_follower_count: 1_234_567,
        ),
      ],
    )

    render

    expect(rendered).to have_content "45.7K"
    expect(rendered).to have_content "1.23M"
  end
end
