class Mangdown::Page

	include Mangdown 

	attr_reader :name, :uri

	def initialize(name, uri)
		@name = name
		@uri  = Mangdown::Uri.new(uri) 
	end

	# explicit conversion to page 
	def to_page
		self
	end	

  # download the page
	def download
    warn "#download is depreciated use #download_to"
		return nil if File.exist?(@name)
    File.open(@name, 'wb') do |file|
			file.write(open(uri).read)
		end
	end

  # downloads to specified directory
  def download_to(dir)
    path = dir + '/' + @name
    # don't download again
    return nil if File.exist?(path)
    File.open(path, 'wb') do |file| 
      file.write(open(uri).read)
    end
  end
end
