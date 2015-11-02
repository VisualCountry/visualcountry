class CreateYoutubeVideo
  def initialize(source)
    @source = source
  end

  def self.perform(source:)
    new(source).perform
  end

  def perform
    YoutubeVideo.create(source: source, guid: guid)
  end

  private

  attr_reader :source

  def guid
    @guid = guid_regex.match(source).to_a[5]
  end

  # Inspired by https://gist.github.com/afeld/1254889
  def guid_regex
    /(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&"'>]+)/
  end
end
