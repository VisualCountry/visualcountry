class ListCopier
  def initialize(old_list)
    @old_list = old_list
  end

  def copy
    old_list.dup.tap do |list|
      list.update(
        name: "#{old_list.name} (copy)",
        uuid: old_list.fresh_uuid,
        profiles: old_list.profiles,
      )
    end
  end

  private

  attr_reader :old_list
end
