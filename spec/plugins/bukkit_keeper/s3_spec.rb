require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bukkit::S3" do
  before(:all) do
    BandwidthUse.delete_all
    @batch = Batch.create!
    attach_sample_file @batch, "#{RAILS_ROOT}/spec/fixtures/example_s3_short.csv"
    @batch.save
  end

  describe "expenses" do
    it "calls quantities" do
      Bukkit::S3.stub!(:quantities).and_return []
      Bukkit::S3.expenses( @batch.entries )
    end
    it "prices storage" do
      Bukkit::S3.expenses( @batch.entries )[:storage].should == 0.13
    end
    it "prices heavy requests" do
      Bukkit::S3.expenses( @batch.entries )[:heavy_requests].should == 0.01
    end
    it "prices light requests" do
      Bukkit::S3.expenses( @batch.entries )[:light_requests].should == 1.57
    end
    it "prices downloads" do
      Bukkit::S3.expenses( @batch.entries )[:downloads].should == 3.52
    end
    it "prices uploads" do
      Bukkit::S3.expenses( @batch.entries )[:uploads].should == 0.0
    end
    it "has a combined price" do
      Bukkit::S3.expenses( @batch.entries )[:all].should == 5.23
    end
  end

  describe "charges" do
    it "calls quantities" do
      Bukkit::S3.stub!(:quantities).and_return []
      Bukkit::S3.charges( @batch.entries )
    end
    it "charges for storage" do
      Bukkit::S3.charges( @batch.entries )[:storage].should == 0.13
    end
    it "charges for heavy requests" do
      Bukkit::S3.charges( @batch.entries )[:heavy_requests].should == 0.01
    end
    it "charges for light requests" do
      Bukkit::S3.charges( @batch.entries )[:light_requests].should == 1.57
    end
    it "charges for downloads" do
      Bukkit::S3.charges( @batch.entries )[:downloads].should == 3.52
    end
    it "charges for uploads" do
      Bukkit::S3.charges( @batch.entries )[:uploads].should == 0.0
    end
    it "has a combined charge" do
      Bukkit::S3.charges( @batch.entries )[:all].should == 5.23
    end
  end

  describe "quantities" do
    it "totals all storage values" do
      (Bukkit::S3.quantities( @batch.entries )[:storage] * 1000 ).ceil.should == 857
    end
    it "totals heavy requests" do
      Bukkit::S3.quantities( @batch.entries )[:heavy_requests].should == 962
    end
    it "totals light requests" do
      Bukkit::S3.quantities( @batch.entries )[:light_requests].should == 1570222
    end
    it "totals upload data" do
      Bukkit::S3.quantities( @batch.entries )[:uploads].should == 43423660.0
    end
    it "totals download data" do
      Bukkit::S3.quantities( @batch.entries )[:downloads].should == 22203187628.0
    end
  end
end
