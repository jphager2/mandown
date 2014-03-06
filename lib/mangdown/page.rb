module Mangdown
  class Page
    attr_reader :filename, :uri

    # like chapter and manga, should initialize with MDHash, and use
    # @info[:key]
    def initialize( uri, filename )

      # this will probably become a problem when adding different
      # Manga sites which may use different file types than .jpg
      @filename = filename + '.jpg'
      @uri = uri
    end

    # this method should probably be moved somewhere else because
    # pages, chapters and mangas can all be "downloaded"
    def download
      unless File.exist?(@filename)
        File.open(@filename, 'wb') do |file|
          file.write(open(URI.encode(@uri, '[]')).read)
        end
      end
    end
  end
end
