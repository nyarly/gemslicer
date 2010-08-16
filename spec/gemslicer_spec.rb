require 'spec_helper'

describe Gemslicer do
  before(:all) do   
    Gemslicer.configure_server_root!(test_server_root)
  end
  
  after(:all) do
    Gemslicer.reset_server_root
    FileUtils.rm_rf(test_server_root)    
  end
  
  context ".server_root" do
    it "should default to the 'server' directory located at the root of gemslicer" do
      Gemslicer.server_root.should =~ /\A#{test_server_root}/
    end
  end

  context ".server_path" do
    it "should start with server_root" do
      Gemslicer.server_path('bar', 'car').should =~ /\A#{test_server_root}/
    end
  end

  context ".proxy_server_path" do
    it "should be rooted under server_root" do
      Gemslicer.proxy_server_path.should =~ /\A#{test_server_root}/
    end

    it "should be 'proxy_tmp'" do
      Gemslicer.proxy_server_path.should =~ /\/proxy_tmp\Z/
    end
    
  end
end
