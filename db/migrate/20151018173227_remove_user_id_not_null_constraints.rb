class RemoveUserIdNotNullConstraints < ActiveRecord::Migration
  def change
    change_column_null(:list_memberships, :user_id, true)
    change_column_null(:organization_memberships, :user_id, true)
  end
end
