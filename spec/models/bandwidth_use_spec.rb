require File.dirname(__FILE__) + '/../spec_helper'

describe "BandwidthUse" do

  before do
    @use = BandwidthUse.new
  end
  it "belongs to a batch" do
    @use.build_batch.should be_an_instance_of(Batch)
    
  end

  describe "searchable scopes - " do
    before(:all) do
      BandwidthUse.delete_all
      @batch = Batch.create
      attach_sample_file(@batch)  
      @batch.parse_s3_report
    end
    it "billable returns all records with a .org in the source" do
      BandwidthUse.billable.count.should == 1707
    end

    it "internal - grabs items with radicaldesigns in the source" do
      BandwidthUse.internal.count(:conditions => "source LIKE '%radicaldesigns%'" ).should == 27
    end
    it "internal - grabs items ending in default" do
      BandwidthUse.internal.count(:conditions => "source LIKE '%-default'").should == 169
    end
    it "internal = should not overlap with billable" do
      BandwidthUse.internal.billable.should be_empty
    end

    it "storage = includes all Storage records" do
      BandwidthUse.storage.count.should == 702
    end

    it "downloads - includes all DataTransferOut records" do
      BandwidthUse.downloads.count.should == 526
    end

    it "uploads - includes all DataTransferIn records" do
      BandwidthUse.uploads.count.should == 107
    end

    it "heavy requests - a per/request tally of uploads and updates" do
      BandwidthUse.heavy_requests.count.should == 154
    end

    it "light requests - a per/request tally of uploads and updates" do
      BandwidthUse.light_requests.count.should == 546
    end

    it "no_charges - includes all NoCharge Usage Types records" do
      BandwidthUse.no_charges.count.should == 60
    end

    it "charges - excludes all NoCharge Usage Types records" do
      BandwidthUse.charges.count.should == 2095 - 60
    end
    it "when combined matches the total # of records" do
      ( 
        BandwidthUse.no_charges.count + 
        BandwidthUse.heavy_requests.count + 
        BandwidthUse.light_requests.count + 
        BandwidthUse.charges.uploads.count + 
        BandwidthUse.charges.downloads.count + 
        BandwidthUse.charges.storage.count).should == 2095 
    end


  end

  describe "calculating expenses" do
    before(:all) do
      BandwidthUse.delete_all
      @batch = Batch.create
      attach_sample_file(@batch)  
      @batch.parse_s3_report
    end

  end
end
