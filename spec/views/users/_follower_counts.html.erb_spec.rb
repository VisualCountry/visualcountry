require "rails_helper"

describe "users/_follower_counts.html.erb" do
  it "displays truncated thousands" do
    assign(
      :user,
      build(
        :user,
        cached_twitter_follower_count: 45_678,
      ),
    )

    render partial: "users/follower_counts", locals: { social: :twitter }

    expect(rendered).to have_content "45.7K"
  end

  it "displays truncated millions" do
    assign(
      :user,
      build(
        :user,
        cached_twitter_follower_count: 1_234_567,
      ),
    )

    render partial: "users/follower_counts", locals: { social: :twitter }

    expect(rendered).to have_content "1.23M"
  end
end
