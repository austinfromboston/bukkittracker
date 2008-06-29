require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bukkit" do
  describe "unique returns a list of unique bucket names in the passed records" do
    it "calls count" do
      test = []
      test.should_receive(:count).and_return(test)
      Bukkit.unique(test)
    end
    it "returns the first element of the returned grouping output" do
      test = [ [ 'test', 34], [ 'test2', 100 ] ]
      test.should_receive(:count).and_return(test)
      Bukkit.unique(test)[1].should == 'test2'
    end
  end
  describe "bucket_qtys returns a list of unique bucket names in the passed records, along with a record count" do
    it "calls count" do
      test = []
      test.should_receive(:count).and_return(test)
      Bukkit.bucket_qtys(test)
    end
  end
end
