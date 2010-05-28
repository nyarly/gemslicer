require File.join(File.dirname(__FILE__), 'spec_helper')

describe Gemslicer do
  after(:each) do
    Gemslicer.reset_server_root
  end
  
  context ".server_root" do
    it "should default to the 'server' directory located at the root of gemslicer" do
      Gemslicer.server_root.should =~ /gemslicer\/server/
    end

    it "should be writable" do
      Gemslicer.server_root  = '/dev/foo'
      Gemslicer.server_root.should == '/dev/foo'
    end
  end

  context ".server_path" do
    it "should start with server_root" do
      Gemslicer.server_root = '/dev/foo'
      Gemslicer.server_path('bar', 'car').should == '/dev/foo/bar/car'
    end
  end
end
