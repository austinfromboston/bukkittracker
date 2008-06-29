require File.dirname(__FILE__) + '/../spec_helper'

describe Batch do
  before do
    @sample_file = "#{RAILS_ROOT}/spec/fixtures/example_s3_monthly.csv"
    @batch = Batch.create!
  end

  describe "current status" do
    it "is created open" do
      @batch.should_not be_closed
    end
    it "can be closed" do
      @batch.close!
      @batch.should be_closed
    end

  end

  describe "entries listing" do
    before do
      attach_sample_file(@batch)
    end
    it "includes bandwidth uses" do
      @batch.save
      @batch.entries.size.should == 2095
    end
  end

  describe "when closed" do
    it "sets closed_at to the current time" do
      close_time = 1.day.ago
      Time.stub!(:now).and_return( close_time )
      @batch.close!
      @batch.closed_at.should == close_time
    end

    describe "when assigned a file" do
      before do
        @batch.stub!(:full_filename).and_return("#{RAILS_ROOT}/spec/fixtures/example_s3_monthly.csv") 
      end
      it "creates bandwidth_use records" do
        @batch.should_receive :parse_s3_report
        @batch.close!
      end
    end
  end

  describe "when parsing s3 reports" do
    before do
      attach_sample_file(@batch)
    end

    def act!; @batch.parse_s3_report; end

    it "opens the file" do
      FasterCSV.should_receive(:foreach).with(@sample_file, hash_including(:headers => true ))
      act!
    end
    it "parses each record" do
      @use_stub = stub_everything
      @batch.bandwidth_uses.should_receive(:create).exactly(2095).times.and_return( @use_stub )
      act!
    end

    it "creates linked use records if the batch is saved" do
      act!
      @batch.bandwidth_uses.should_not be_empty
    end

    it " transfers all values" do
      act!
      b = BandwidthUse.find_by_amount(2027162040)
      [ b.source, b.usage_type, b.units, b.amount.to_s ].should == %w| seiuvoice.org storage gigabyte/months 2027162040| 
      b.source.should_not be_nil
      
    end

    it "closes the batch when saved with an attachment" do
      @batch.should_receive( :close! )
      @batch.save
      
    end

  end

end

