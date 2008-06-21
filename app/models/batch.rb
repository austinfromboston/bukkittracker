class Batch < ActiveRecord::Base
  has_attachment :max_size => 3.megabytes, :storage => :file_system
  validates_as_attachment

  has_many :bandwidth_uses
end
