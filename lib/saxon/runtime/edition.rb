require "fileutils"
require "rbconfig"
require "tempfile"
require "open-uri"
require "zip"

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

      Dir.mktmpdir("saxonc") do |temp_dir|
        zip_path = File.join(temp_dir, "saxonc.zip")

        begin
          STDERR.puts "Downloading SaxonC from #{download_url}..."
          URI.open(download_url) do |saxon_archive|
            File.binwrite(zip_path, saxon_archi.read)
          end
        rescue OpenURI::HTTPError => e
          raise "Failed to download SaxonC from #{download_url}, perhaps the version or platform is not supported: #{e.message}"
        rescue StandardError => e
          raise "An error occurred while downloading SaxonC: #{e.message}"
        end

        STDERR.puts "Extracting SaxonC..."
        Zip::File.open(zip_path) do |zip|
          zip.each do |entry|
            dest = File.join(temp_dir, entry.name)
            FileUtils.mkdir_p(File.dirname(dest))
            entry.extract(dest) { true }
          end
        end

        extracted_dir = Dir.glob(File.join(temp_dir, "*"))
                           .find { |p| File.directory?(p) }

        raise "Failed to extract SaxonC archive" unless extracted_dir

        FileUtils.mkdir_p(File.dirname(path))
        FileUtils.rm_rf(path)
        FileUtils.mv(extracted_dir, path)
        STDOUT.puts "\nSuccessfully installed SaxonC to #{path}!\n"
      ensure
        FileUtils.rm_rf(temp_dir) if temp_dir && Dir.exist?(temp_dir)
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

  end

  HE = Class.new(Edition)
  PE = Class.new(Edition)
  EE = Class.new(Edition)
end
