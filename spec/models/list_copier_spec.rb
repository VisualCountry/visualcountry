require "rails_helper"

describe ListCopier do
  describe "#copy" do
    it "appends \"(copy)\" to the name of the list" do
      old_list = build(:influencer_list)

      new_list = ListCopier.new(old_list).copy

      expect(new_list.name).to eq "#{old_list.name} (copy)"
    end

    it "creates a new UUID for the new list" do
      old_list = build(:influencer_list)

      new_list = ListCopier.new(old_list).copy

      expect(new_list.uuid).not_to eq old_list.uuid
    end

    it "keeps the same profiles" do
      profile = create(:profile)
      old_list = create(:influencer_list, profiles: [profile])

      new_list = ListCopier.new(old_list).copy

      expect(new_list.profiles).to eq old_list.profiles
    end

    it "keeps the same owner" do
      owner = create(:profile)
      old_list = create(:influencer_list, owner: owner)

      new_list = ListCopier.new(old_list).copy

      expect(new_list.owner).to eq old_list.owner
    end
  end
end
