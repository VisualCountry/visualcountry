class ListCopier
  def initialize(old_list)
    @old_list = old_list
  end

  def copy
    old_list.dup.tap do |list|
      list.update(
        name: "#{old_list.name} (copy)",
        uuid: old_list.fresh_uuid,
        users: old_list.users,
      )
    end
  end

  private

  attr_reader :old_list
end
