module Mangdown 

	extend self

  def eql?(other)
    (self.name == other.name) and (self.uri == other.uri)
  end

	def ==(other)
		puts "You may want to use :eql?"
		super
	end
end

