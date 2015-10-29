class Profile < ActiveRecord::Base
  belongs_to :user

  has_and_belongs_to_many :interests
  has_and_belongs_to_many :focuses
  has_and_belongs_to_many :clients

  has_many :press, dependent: :destroy
  has_many :list_memberships, dependent: :destroy
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships

  enum gender: {
    'Female'  => 0,
    'Male'    => 1,
    'Other'   => 2,
  }

  enum ethnicity: {
    'Hispanic or Latino'                        => 0,
    'Native American'                           => 1,
    'Asian'                                     => 2,
    'Black or African American'                 => 3,
    'Native Hawaiian or other Pacific Islander' => 4,
    'White'                                     => 5,
    'Other/prefer not to answer'                => 6,
  }

  has_attached_file :picture,
    default_url: 'missing.png',
    styles: {
      medium: '300x300#',
      thumb: '50x50#'
    }
  crop_attached_file :picture
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  has_paper_trail
end
