class CreateVimeoVideo
  def initialize(source)
    @source = source
  end

  def self.perform(source:)
    new(source).perform
  end

  def perform
    VimeoVideo.create(source: source, guid: guid)
  end

  private

  attr_reader :source

  def guid
    @guid = guid_regex.match(source).to_a[5]
  end

  def guid_regex
    /^.*(vimeo\.com\/)((channels\/[A-z]+\/)|(groups\/[A-z]+\/videos\/))?([0-9]+)/
  end
end
