class Interest < ActiveRecord::Base
  has_and_belongs_to_many :users #TODO: Remove after rake task has been run
  has_and_belongs_to_many :profiles

  default_scope { order(:name) }
end
