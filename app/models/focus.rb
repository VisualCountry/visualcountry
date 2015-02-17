class Focus < ActiveRecord::Base
  has_and_belongs_to_many :users

  def as_json(options)
    {
      id: id,
      name: name,
    }
  end
end
