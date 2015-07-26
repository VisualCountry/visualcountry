class Press < ActiveRecord::Base
  belongs_to :user #TODO: Remove after rake task has been run:w
  belongs_to :profile
end
