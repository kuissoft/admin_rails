class Location < ActiveRecord::Base
  belongs_to :session
  
  validates :session,
    uniqueness: true
  validates :lat,
    inclusion: { in: -90..90, message: " is not a valid latitude" }
  validates :lon,
    inclusion: { in: -180..180, message: " is not a valid longitude" }
  validates :bearing, 
    inclusion: { in: 0..359, message: " must be within 0 to 359" }, 
    numericality: { only_integer: true }
    
    scope :sorted, -> { order("created_at DESC") }
end
