module Mangdown
  class PopularManga

    attr_reader :uri, :mangas_list, :mangas, :name

    def initialize(uri, num_mangas = 0, name = "My Pop Manga")
      @uri = uri 
      @num_mangas = num_mangas
      @name = name

      @mangas_list = []

      #Depreciated
      @mangas = []

      get_mangas_list
    end

    #Depreciated use MDHash.get_manga
    def get_manga(number)
      puts "This has been depreciated, don't use PopularManga @mangas!"
      manga  = @mangas_list[number - 1]

      unless @mangas.find {|mnga| (mnga.name == manga[:name]) or 
                                   (mnga.uri == manga[:uri])}
        @mangas << manga.to_manga
      else
        puts "This manga has already been added.."
      end
    end

    private
      def get_mangas_list
        (@num_mangas / 30.0).ceil.times do |time|
          get_pop_page_manga(time).each do |manga| 
            @mangas_list << manga
          end
        end
      end

      def get_pop_page_manga(time)
        root = Tools.get_root(@uri)

        num = 30 * (time)
        page = root + '/popular/' + num.to_s
        doc = Tools.get_doc(page)

        last = (@num_mangas > 30) ? 30 : @num_mangas
        @num_mangas -= 30

        get_manga_on_page(doc, root)[0..(last - 1)]
      end

      def get_manga_on_page(doc, root)
        doc.css('h3 a').map do |a| 
          MDHash.new({
            uri: (root + a['href']),
            name: a.text
          })
        end
      end
  end
end
