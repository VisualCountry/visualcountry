class Focus < ActiveRecord::Base
  has_and_belongs_to_many :users

  default_scope { order(:name) }

  def as_json(options)
    {
      id: id,
      name: name,
    }
  end
end
