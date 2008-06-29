require 'faster_csv'
class Batch < ActiveRecord::Base
  has_attachment :max_size => 3.megabytes, :storage => :file_system

  has_many :bandwidth_uses
  alias :entries :bandwidth_uses

  def closed?
    !closed_at.nil?
  end


  def close!
    update_attribute :closed_at, Time.now
    parse_s3_report
  end

  def parse_s3_report
    return unless filename
    FasterCSV.foreach(full_filename, {
      :header_converters => lambda { |field| field.strip.underscore.to_sym if field },
      :headers => true,
      :skip_blanks => true }) do |csv_data|

        next unless csv_data[:usage_value]
        usage_key = Bukkit::S3::USAGE_TYPES.select { |key, text| csv_data[:usage_type].include? text }.flatten.first
        bandwidth_uses.create( 
            :amount       => csv_data[:usage_value].to_i, 
            :source       => csv_data[:resource], 
            :usage_type   => usage_key.to_s,
            :units        => Bukkit::S3::UNITS[ usage_key ],
            :started_at   => Time.parse(csv_data[:start_time] ),
            :completed_at => Time.parse(csv_data[:end_time] ),
            :request_method => Bukkit::S3::REQUEST_METHODS.select { |method, value| 
                value = [ value ] unless value.is_a?(Array)
                value.any? { |v| csv_data[:operation].include?( v ) } 
              }.flatten.first 

          )
    end
  end

  after_save { |batch| batch.close! unless batch.closed? || batch.filename.nil? }
  

end
