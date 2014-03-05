class Book

	attr_accessor :rank
	attr_accessor :author
	attr_accessor :title
	attr_accessor :language
	attr_accessor :published
	attr_accessor :sold

	@@numberOfBooks = 0
	def initialize()
		@@numberOfBooks += 1
		@rank = @@numberOfBooks
		@author = nil
		@title = nil
		@language = nil
		@published = nil
		@sold = 0
		
	end


end