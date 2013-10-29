require 'spec_helper'

module Mandown
  describe Page do
   	before(:all) do
		  @dir = Dir.pwd
	    @uri = 'http://i25.mangareader.net/bleach/537/bleach-4149721.jpg'
	    @filename = "Bleach 537 - Page 1" 
	    @page = Page.new( @uri, @filename )
	    @page.download
      PAGE_STUB_PATH = File.expand_path('../../objects/page.yml', __FILE__)
      File.open(PAGE_STUB_PATH, 'w+') do |file| 
        file.write(@page.to_yaml)
      end
		  @page2 = YAML.load(File.open(PAGE_STUB_PATH, 'r').read)
    end

    context "when page is downloaded" do
      it "should download itself to the current directory" do
        expect(Dir.glob(@dir + '/*')).to include(@dir + '/' + @page.filename)
      end
    end

		context "when a page is compared with a page loaded from a .yml file" do
      it "should compare with #eql?" do
	  		expect(@page.eql?(@page2))
			end 

			it "should not compare with ==" do
				expect(!@page == @page2)
			end
		end
  end
end
