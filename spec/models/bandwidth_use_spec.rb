require File.dirname(__FILE__) + '/../spec_helper'

describe BandwidthUse do
  before do
    @use = BandwidthUse.new
  end
  it "belongs to a batch" do
    @use.build_batch.should be_an_instance_of(Batch)
    
  end
end
