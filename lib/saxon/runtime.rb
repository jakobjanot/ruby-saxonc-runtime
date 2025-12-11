# frozen_string_literal: true
require_relative "runtime/version"
require "fileutils"

module Saxon
  module Runtime
    class Error < StandardError; end
    class UnknownEdition < Error; end;
    class UnsupportedPlatform < Error; end;

    class << self
      def edition
        @edition || Saxon::Runtime::HE.new
      end

      def edition=(edition)
        @edition = edition
      end

      def base_dir
        @base_dir ||= File.join(File.expand_path('~'), '.saxonc')
      end

      def base_dir=(dir)
        @base_dir = dir
      end

      def path
        edition.path
      end

      # Removes the local saxon copies
      def implode!
        FileUtils.rm_rf File.join(File.expand_path('~'), '.saxonc')
      end

      # Clears cached state. Primarily useful for testing.
      def reset!
        @base_dir = @path = @edition = @version = nil
      end
    end
  end
end

require 'saxon/runtime/edition'