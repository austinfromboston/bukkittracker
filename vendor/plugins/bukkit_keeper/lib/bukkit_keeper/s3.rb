module Bukkit
  def unique( bandwidth_uses )
    bucket_qtys(bandwidth_uses).map(&:first)
  end
  def bucket_qtys( bandwidth_uses )
    bandwidth_uses.count( :group => 'source' )
  end
  module_function :unique, :bucket_qtys

  class S3
    def self.expenses( bandwidth_uses )
      totals = Hash[*quantities(bandwidth_uses).map do | key, value | 
        value = ( value.to_f / 1.gigabyte ) if [:uploads, :downloads].include?( key )
        [ key, ( value ? ("%0.2f" % ( value * EXPENSES[key].to_f )).to_f : 0 ) ] 
      end.flatten ]
      totals.merge( :all => totals.values.inject(&:+) )
    end

    def self.charges( bandwidth_uses )
      totals = Hash[*quantities(bandwidth_uses).map do | key, value | 
        value = ( value.to_f / 1.gigabyte ) if [:uploads, :downloads].include?( key )
        [ key, ( value ? ("%0.2f" % ( value * CHARGES[key].to_f )).to_f : 0 ) ] 
      end.flatten ]
      totals.merge( :all => totals.values.inject(&:+) )
    end

    def self.quantities( bandwidth_uses )
      {
        #storage is converted from byte-hours to gigabyte-months
        :storage => bandwidth_uses.storage.sum(:amount).to_f / (1.gigabyte * 24 * 30 ),
        :uploads => bandwidth_uses.uploads.sum(:amount).to_f,
        :downloads => bandwidth_uses.downloads.sum(:amount).to_f,
        :heavy_requests => bandwidth_uses.heavy_requests.sum(:amount),
        :light_requests => bandwidth_uses.light_requests.sum(:amount)
        }
    end
  end
end
