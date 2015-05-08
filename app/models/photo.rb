class Photo < ActiveRecord::Base
  belongs_to :album
  has_attached_file :file,
    styles: {
      large: "1000x1000",
      medium: "800x800",
      thumb: "300x300",
      square: "300x100#" }, default_url: "/images/:style/missing.png"
end

