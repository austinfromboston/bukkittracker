class BandwidthUse < ActiveRecord::Base
  belongs_to :batch

  named_scope :billable, :conditions => "source LIKE '%.org%'" 

  named_scope :internal, :conditions => "source LIKE '%radicaldesigns' OR source LIKE '%-default' OR source = NULL"

  named_scope :storage,         :conditions => [ "usage_type = ?", "storage" ]
  named_scope :downloads,       :conditions => [ "usage_type = ?", "download" ]
  named_scope :uploads,         :conditions => [ "usage_type = ?", "upload" ]
  named_scope :heavy_requests,  :conditions => [ 'usage_type = ?', "heavy_request" ]
  named_scope :light_requests,  :conditions => [ 'usage_type = ?', "light_request" ]
  named_scope :no_charges,      :conditions => [ "usage_type = ?", 'no_charge' ]
  named_scope :charges,         :conditions => [ "usage_type != ?", "no_charge" ]

  named_scope :by_source,       lambda{ |source| { :conditions => { :source => source }}}
  
end
