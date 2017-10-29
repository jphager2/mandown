# frozen_string_literal: true

module Mangdown
  # Mangdown manga object, which holds chapters
  class Manga
    include Equality
    include Enumerable
    include Logging

    attr_reader :uri, :chapters, :name
    attr_accessor :adapter

    def initialize(uri, name)
      @name = name
      @uri = Addressable::URI.escape(uri)
      @chapters = []
    end

    def cbz
      CBZ.all(to_path)
    end

    def download(*args)
      download_to(nil, *args)
    end

    # download using enumerable
    def download_to(dir, start = 0, stop = -1, opts = { force_download: false })
      start, stop = validate_indeces!(start, stop)
      setup_download_dir!(dir)
      failed = []
      succeeded = []
      skipped = []

      chapters[start..stop].each do |md_hash|
        chapter = md_hash.to_chapter
        chapter_result = chapter.download_to(to_path, opts)

        if chapter_result[:failed].any?
          failed << chapter
        elsif chapter_result[:succeeded].any?
          succeeded << chapter
        elsif chapter_result[:skipped].any?
          skipped << chapter
        end
        next unless chapter_result[:failed].any?
        logger.error({
          msg: 'Chapter was not fully downloaded',
          uri: chapter.uri,
          chapter: chapter.name
        }.to_s)
      end
      { failed: failed, succeeded: succeeded, skipped: skipped }
    end

    def to_manga
      self
    end

    def to_path
      @path ||= set_path
    end

    def set_path(dir = nil)
      dir ||= DOWNLOAD_DIR
      path = File.join(dir, name)
      @path = Tools.relative_or_absolute_path(path)
    end

    def each(&block)
      @chapters.each(&block)
    end

    def load_chapters
      @chapters += adapter.chapter_list.map do |chapter|
        chapter[:manga] = name
        MDHash.new(chapter)
      end
    end

    private

    def chapter_indeces(start, stop)
      length = chapters.length
      [start, stop].map { |i| i.negative? ? length + i : i }
    end

    def setup_download_dir!(dir)
      set_path(dir)
      FileUtils.mkdir_p(to_path) unless Dir.exist?(to_path)
    end

    def validate_indeces!(start, stop)
      chapter_indeces(start, stop).tap do |i_start, i_stop|
        last = chapters.length - 1

        if i_start > last || i_stop > last
          error = "This manga has chapters in the range (0..#{last})"
          raise Mangdown::Error, error
        elsif i_stop < i_start
          error = 'Last index must be greater than or equal to first index'
          raise Mangdown::Error, error
        end
      end
    end
  end
end
