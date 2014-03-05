#!/usr/bin/ruby
#Craig Carlson
#Homework 8

require 'rack'
require_relative 'Book'

class BookApp
	def initialize()
		@time = Time.now
		@listOfBooks = []
	end

	def call(env)
		#This creates the request and response that allows us to interface between our ruby and html code and the rails code
		request = Rack::Request.new(env)
		response = Rack::Response.new

		#Get the html header
		File.open("header.html", "r") { |head| response.write(head.read) }
		case env["PATH_INFO"]
		  when /.*?\.css/
		  	#supplies the css file that is associated with the html file
		  	file = env["PATH_INFO"][1..-1]
		  	return [200, {"Content-Type" => "text/css"}, [File.open(file, "rb").read]]
		  when /\/author.*/
		  	#This will be the approach to call functions that have access to the html and css
		  	render_author(request, response)
		  when /\.*/
		  	render_file(request, response)
		  	render_displayBooks(request, response)
		  else
		  	[404, {"Content-Type" => "text/plain"}, ["Error 404!"]]
		end

		response.finish
	end

	def render_author(req, response)
		response.write("This is just crazy! #{@time}")
	end

	def render_file(req, response)
		counter = 1
		filename = "books.txt"
		response.write("<h1>This is the content of #{filename} </h1>")
		begin
		    file = File.new(filename, "r")
		    while (line = file.gets)
		    	#response.write("#{counter} ")
		    	line = line.strip()		    	
		    	attributes = line.split(',')

		    	#response.write("#{attributes[0]} #{attributes[1]} #{attributes[2]} #{attributes[3]} #{attributes[4]} </br>")

		    	newBook = Book.new()
		    	newBook.title = attributes[0]		    	
		    	newBook.author = attributes[1]		    	
		    	newBook.language = attributes[2]		    
		    	newBook.published = attributes[3]
		    	newBook.sold = attributes[4]

		    	@listOfBooks << newBook


		        counter = counter + 1
		    end
		    file.close
		rescue => err
		    puts "Exception: #{err}"
		    err
		end
	end

	def render_displayBooks(req, response)
		#response.write(@listOfBooks.length)
		response.write("<table id = \"bookTable\">")
		response.write("<tr> <th>Rank</th> <th>Title</th> <th>Author</th> <th>Language</th> <th>Published</th> <th>Copies Sold</th> </tr>")
		@listOfBooks.each { |book|
			response.write("<tr>")
			response.write("<td> #{book.rank} </td>")
			response.write("<td> #{book.title} </td>")
			response.write("<td> #{book.author} </td>")
			response.write("<td> #{book.language} </td>")
			response.write("<td> #{book.published} </td>")
			response.write("<td> #{book.sold} </td>")
			response.write("</tr>")
		}
		response.write("<tr><tfoot> Posted by: Craig Carlson </tfoot></tr>")
		
		response.write("</table>")
		#response.write("Finished")
	end
end

Signal.trap('INT') {
	Rack::Handler::WEBrick.shutdown
}

Rack::Handler::WEBrick.run BookApp.new, :Port => 8080