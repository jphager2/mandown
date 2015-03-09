module Mangdown
	class Properties

		attr_reader :info, :type

		def initialize(site)
			@info = Hash.new

      case site 
      when /mangareader/
        @type = :mangareader
				mangareader
      when /mangapanda/ 
        #mangapanda is a mirror of mangareader
        #that being said, I really don't think this works
        #especially with @info[:root]
        @type = :mangapanda
        mangareader
      when /mangafox/
        @type = :mangafox
				mangafox
      else
        nil
      end
		end

		def mangareader
			@info[:manga_list_css_klass] = 'ul.series_alpha li a'
			@info[:manga_css_klass]      = 'div#chapterlist td a'
			@info[:chapter_klass]        = MRChapter
			@info[:root]                 = 'http://www.mangareader.net'
			@info[:manga_link_prefix]    = @info[:root] 
			@info[:reverse]              = false
      @info[:manga_url_regex]      = //
      @info[:chapter_url_regex]    = //
      @info[:page_url_regex]       = //
		end

		def mangafox
			@info[:manga_list_css_klass] = 'div.manga_list li a'
			@info[:manga_css_klass]      = 'a.tips'
			@info[:chapter_klass]        = MFChapter
			@info[:root]                 = 'http://mangafox.me'
			@info[:manga_link_prefix]    = ''
			@info[:reverse]              = true
      @info[:manga_url_regex]      = 
        /#{@info[:root]}\/manga\/[^\/]+?\//
      @info[:chapter_url_regex]    = //
      @info[:page_url_regex]       = //
		end

    def is_manga?(obj)
      obj.uri.slice(@info[:manga_url_regex]) == obj.uri
    end

    def is_chapter?(obj)
      obj.uri.slice(@info[:chapter_url_regex]) == obj.uri
    end

    def is_page?(obj)
      obj.uri.slice(@info[:page_url_regex]) == obj.uri
    end

    def empty?
      @info.empty?
    end

		private
    def method_missing(method, *args, &block)
      # this should probably be if @info.has_key?(method)
      # or more consisely @info.fetch(method) { super }
      return @info[method] unless @info[method].nil?
      super
    end
	end
end
