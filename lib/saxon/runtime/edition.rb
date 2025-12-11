module Saxon::Runtime
  class Edition
    attr_reader :version, :platform

    VERSION_REGEX = /\A(\d+)\.(\d+)\.(\d+)\z/
    def initialize(version = Saxon::Runtime::SAXON_VERSION)
      unless version.match?(VERSION_REGEX)
        raise ArgumentError, "Invalid version format: #{version}. Expected format: 'X.Y.Z'"
      end
      @version = version

      unless platform
        raise "Unsupported platform: #{os or "unknown"}-#{arch or "unknown"}"
      end
      @platform = platform
    end

    def path
      File.expand_path File.join(Saxon::Runtime.base_dir, version, edition, platform)
    end

    def installed?
      File.exist?(path)
    end

    def available_platforms
      [
        'linux-x86_64',
        'linux-aarch64',
        'macos-x86_64',
        'macos-arm64',
        'windows-x86_64'
      ]
    end

    def platform
      platform = "#{os}-#{arch}"
      available_platforms.include?(platform) ? platform : nil
    end

    def download_url
      "https://downloads.saxonica.com/SaxonC/#{edition}/#{version_major}/SaxonCHE-#{platform}-#{version_major}-#{version_minor}-#{version_patch}.zip"
    end

    def install!
      STDERR.puts "SaxonC does not appear to be installed in #{path}, installing!"
      FileUtils.mkdir_p Saxon::Runtime.base_dir

      Tempfile.create("saxonc.zip") do |zip_file|

        begin
          zip_file.open "wb" do |file|
            STDERR.puts "Downloading SaxonC from #{download_url}..."
            file.write URI.open(download_url).read
          end
        rescue OpenURI::HTTPError => e
          raise "Failed to download SaxonC from #{download_url}, perhaps the version or platform is not supported: #{e.message}"
        rescue StandardError => e
          raise "An error occurred while downloading SaxonC: #{e.message}"
        end

        STDERR.puts "Extracting SaxonC..."
        Zip::File.open(zip_file.path) do |zip_file|
          zip_file.each do |entry|
            entry.extract(File.join(temp_dir, entry.name))
          end
        end

        extracted_dir = Dir['saxonc*'].find { |path| File.directory?(path) }

        if FileUtils.mv extracted_dir, path
          STDOUT.puts "\nSuccessfully installed SaxonC to #{path}!\n"
        end

        if FileUtils.rm_rf temp_dir
          STDOUT.puts "Removed temporarily downloaded files."
        end
      end

      raise "Failed to install SaxonC. Sorry :(" unless File.exist?(path)
    end

    def ensure_installed!
      install! unless installed?
    end

    private

    def version_major
      version.split('.')[0]
    end

    def version_minor
      version.split('.')[1]
    end

    def version_patch
      version.split('.')[2]
    end

    def os
      case RbConfig::CONFIG['host_os']
      when /linux/
        'linux'
      when /darwin/
        'macos'
      when /mswin|mingw|cygwin/
        'windows'
      else
        nil
      end
    end

    def arch
      RbConfig::CONFIG['host_cpu']
    end

    def edition
      self.class.name.split('::').last
    end

    def temp_path
      ENV['TMPDIR'] || ENV['TEMP'] || '/tmp'
    end
  end

  HE = Class.new(Edition)
  PE = Class.new(Edition)
  EE = Class.new(Edition)
end
