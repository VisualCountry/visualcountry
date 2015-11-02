class CreateYoutubePortfolioItem
  def initialize(profile, source)
    @profile = profile
    @source = source
  end

  def self.perform(profile:, source:)
    new(profile, source).perform
  end

  def perform
    create_youtube_video
    create_portfolio_item
  end

  private

  attr_reader :portfolio_item, :profile, :source, :video

  def create_youtube_video
    @video = CreateYoutubeVideo.perform(source: source)
  end

  def create_portfolio_item
    PortfolioItem.create!(profile_id: profile.id, item: video)
  end
end
