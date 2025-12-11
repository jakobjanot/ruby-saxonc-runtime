require 'spec_helper'

RSpec.describe Saxon::Runtime::HE do
  before(:each) { Saxon::Runtime.reset! }
  
  context "on a linux x86_64" do
    before(:each) do
      Saxon::Runtime.edition = Saxon::Runtime::HE.new("15.9.1")
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('linux-gnu')
      allow(RbConfig::CONFIG).to receive(:[]).with('host_cpu').and_return('x86_64')
      allow(Saxon::Runtime).to receive(:version).and_return('15.9.1')
    end
    it "returns the correct path" do
      expect(Saxon::Runtime.path).to include(".saxonc/15.9.1/HE/linux-x86_64")
    end
    
    it "returns the correct download URL" do
      expect(Saxon::Runtime.edition.download_url).to eq \
        "https://downloads.saxonica.com/SaxonC/HE/15/SaxonCHE-linux-x86_64-15-9-1.zip"
    end
  end

  context "on a linux aarch64" do
    before(:each) do
      Saxon::Runtime.edition = Saxon::Runtime::HE.new("15.9.1")
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('linux-gnu')
      allow(RbConfig::CONFIG).to receive(:[]).with('host_cpu').and_return('aarch64')
      allow(Saxon::Runtime).to receive(:version).and_return('15.9.1')
    end
    it "returns the correct path" do
      expect(Saxon::Runtime.path).to include(".saxonc/15.9.1/HE/linux-aarch64")
    end

    it "returns the correct download URL" do
      expect(Saxon::Runtime.edition.download_url).to eq \
        "https://downloads.saxonica.com/SaxonC/HE/15/SaxonCHE-linux-aarch64-15-9-1.zip"
    end
  end

  context "on a macos x86_64" do
    before(:each) do
      Saxon::Runtime.edition = Saxon::Runtime::HE.new("15.9.1")
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('darwin21.6.0')
      allow(RbConfig::CONFIG).to receive(:[]).with('host_cpu').and_return('x86_64')
      allow(Saxon::Runtime).to receive(:version).and_return('15.9.1')
    end
    it "returns the correct path" do
      expect(Saxon::Runtime.path).to include(".saxonc/15.9.1/HE/macos-x86_64")
    end

    it "returns the correct download URL" do
      expect(Saxon::Runtime.edition.download_url).to eq \
        "https://downloads.saxonica.com/SaxonC/HE/15/SaxonCHE-macos-x86_64-15-9-1.zip"
    end
  end

  context "on a macos arm64" do
    before(:each) do
      Saxon::Runtime.edition = Saxon::Runtime::HE.new("15.9.1")
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('darwin21.6.0')
      allow(RbConfig::CONFIG).to receive(:[]).with('host_cpu').and_return('arm64')
      allow(Saxon::Runtime).to receive(:version).and_return('15.9.1')
    end
    it "returns the correct path" do
      expect(Saxon::Runtime.path).to include(".saxonc/15.9.1/HE/macos-arm64")
    end
    
    it "returns the correct download URL" do
      expect(Saxon::Runtime.edition.download_url).to eq \
        "https://downloads.saxonica.com/SaxonC/HE/15/SaxonCHE-macos-arm64-15-9-1.zip"
    end
  end

  context "on a windows x86_64" do
    before(:each) do
      Saxon::Runtime.edition = Saxon::Runtime::HE.new("15.9.1")
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('mingw32')
      allow(RbConfig::CONFIG).to receive(:[]).with('host_cpu').and_return('x86_64')
      allow(Saxon::Runtime).to receive(:version).and_return('15.9.1')
    end
    it "returns the correct path" do
      expect(Saxon::Runtime.path).to include(".saxonc/15.9.1/HE/windows-x86_64")
    end
    
    it "returns the correct download URL" do
      expect(Saxon::Runtime.edition.download_url).to eq \
        "https://downloads.saxonica.com/SaxonC/HE/15/SaxonCHE-windows-x86_64-15-9-1.zip"
    end
  end

  context "on an unsupported OS" do
    before(:each) do
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('solaris11')
      allow(RbConfig::CONFIG).to receive(:[]).with('host_cpu').and_return('sparc')
      allow(Saxon::Runtime).to receive(:version).and_return('15.9.1')
    end

    it "returns the correct path" do
      expect { Saxon::Runtime::HE.new("15.9.1") }.to raise_error("Unsupported platform: unknown-sparc")
    end
  end
end

RSpec.describe Saxon::Runtime::PE do
  before(:each) { Saxon::Runtime.reset! }

  context "on a linux x86_64" do
    before(:each) do
      Saxon::Runtime.edition = Saxon::Runtime::PE.new("15.9.1")
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('linux-gnu')
      allow(RbConfig::CONFIG).to receive(:[]).with('host_cpu').and_return('x86_64')
    end
    it "returns the correct path" do
      expect(Saxon::Runtime.path).to include(".saxonc/15.9.1/PE/linux-x86_64")
    end

    it "returns the correct download URL" do
      expect(Saxon::Runtime.edition.download_url).to eq \
        "https://downloads.saxonica.com/SaxonC/PE/15/SaxonCHE-linux-x86_64-15-9-1.zip"
    end
  end
end