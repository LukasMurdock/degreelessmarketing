require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'json'
require 'httparty'
require "open-uri"

# Set directories
root_dir =  File.expand_path(".", Dir.pwd)
book_dir = File.join(root_dir, "_books/")
data_dir = File.join(root_dir, "_data/")
image_dir = File.join(root_dir, "assets/images/books/")


check_array = []
currentOrderArray = []
Dir.foreach(book_dir) do |filename|
    next if filename == '.' or filename == '..'
    # Do work on the remaining files & directories
    fileRead = YAML.load_file(book_dir+filename)
    
    unless fileRead.include? 'link' then
      puts "Getting Link for "+filename
      file = File.open(book_dir+filename, "r+")
      bookYaml = YAML.load(File.read(book_dir+filename))
      bookMarkdown = File.read(book_dir+filename)
      file.close
      
      bookText = bookMarkdown.partition("\n---\n").last
      bookArray = bookYaml.to_a

      linkYaml = "https://www.google.com/search?q=" + CGI.escape(fileRead["title"].to_s) + "+by+" + CGI.escape(fileRead["author"].to_s)
      insert_array = ["link", "#{linkYaml}"]

      bookArray.insert(3, insert_array)

      bookYaml = bookArray.to_h.to_yaml + "\n---\n" + bookText
      
      File.open(book_dir+filename, "w") {|f| f.write(bookYaml)}
    end


    unless fileRead.include? 'image' then
      puts "Getting Image for "+filename
        # p filename
        check_array.push(fileRead["isbn"])
        api_url = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + fileRead["isbn"].to_s + "+&fields=items(volumeInfo/imageLinks/thumbnail,volumeInfo/industryIdentifiers/identifier,volumeInfo/categories)+&maxResults=40"
        
        begin
            response = HTTParty.get(api_url)
          rescue HTTParty::Error
            # don´t do anything / whatever
          rescue StandardError
            # rescue instances of StandardError,
            # i.e. Timeout::Error, SocketError etc
        end



        # p api_url
            # p response.parsed_response
            unless response.parsed_response.empty? then
              unless response.parsed_response["items"][0]["volumeInfo"]["imageLinks"].nil? then

                image_url = response.parsed_response["items"][0]["volumeInfo"]["imageLinks"]["thumbnail"]
                imageName = File.basename(book_dir+filename, ".md")

                URI.open(image_url) do |image|
                    File.open(image_dir+imageName+".jpg", "wb") do |file|
                      file.write(image.read)
                    end
                end

                file = File.open(book_dir+filename, "r+")
                bookYaml = YAML.load(File.read(book_dir+filename))
                bookMarkdown = File.read(book_dir+filename)
                file.close



                bookText = bookMarkdown.partition("\n---\n").last
                bookArray = bookYaml.to_a
          
                insert_array = ["image", "#{imageName+'.jpg'}"]
          
                bookArray.insert(3, insert_array)
          
                bookYaml = bookArray.to_h.to_yaml + "\n---\n" + bookText
                
                File.open(book_dir+filename, "w") {|f| f.write(bookYaml)}
              end
            end
    end


    unless fileRead.include? 'category' then
      puts "Getting Category for "+filename
      # p filename
      check_array.push(fileRead["isbn"])
      api_url = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + fileRead["isbn"].to_s + "+&fields=items(volumeInfo/industryIdentifiers/identifier,volumeInfo/categories)+&maxResults=40"
      
      begin
          response = HTTParty.get(api_url)
        rescue HTTParty::Error
          # don´t do anything / whatever
        rescue StandardError
          # rescue instances of StandardError,
          # i.e. Timeout::Error, SocketError etc
      end

      # p api_url
          # p response.parsed_response
          unless response.parsed_response.empty? then
            
            print "** found_category: "
            p response.parsed_response["items"][0]["volumeInfo"]["categories"]
              unless response.parsed_response["items"][0]["volumeInfo"]["categories"].nil? then

                category = response.parsed_response["items"][0]["volumeInfo"]["categories"][0]

                file = File.open(book_dir+filename, "r+")
                bookYaml = YAML.load(File.read(book_dir+filename))
                bookMarkdown = File.read(book_dir+filename)
                file.close

                bookText = bookMarkdown.partition("\n---\n").last
                bookArray = bookYaml.to_a
          
                insert_array = ["category", "#{category}"]
          
                bookArray.insert(3, insert_array)
          
                bookYaml = bookArray.to_h.to_yaml + "\n---\n" + bookText
                
                File.open(book_dir+filename, "w") {|f| f.write(bookYaml)}
              end

          end

  end


  unless fileRead.include? 'slug' then
    puts "Getting Slug for "+filename
    file = File.open(book_dir+filename, "r+")
    bookYaml = YAML.load(File.read(book_dir+filename))
    bookMarkdown = File.read(book_dir+filename)
    file.close

    slug = bookYaml["title"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

    bookText = bookMarkdown.partition("\n---\n").last
    bookArray = bookYaml.to_a

    insert_array = ["slug", "#{slug}"]

    bookArray.insert(3, insert_array)

    bookYaml = bookArray.to_h.to_yaml + "\n---\n" + bookText
    
    File.open(book_dir+filename, "w") {|f| f.write(bookYaml)}

  end


  unless fileRead.include? 'description' then
    puts "Getting Description for "+filename
    file = File.open(book_dir+filename, "r+")
    bookYaml = YAML.load(File.read(book_dir+filename))
    bookMarkdown = File.read(book_dir+filename)
    file.close

    descriptionText = bookYaml["title"]+" is part of a collection of books to help you do better marketing."

    bookText = bookMarkdown.partition("\n---\n").last
    bookArray = bookYaml.to_a

    insert_array = ["description", "#{descriptionText}"]

    bookArray.insert(3, insert_array)



    bookYaml = bookArray.to_h.to_yaml + "\n---\n" + bookText
    
    File.open(book_dir+filename, "w") {|f| f.write(bookYaml)}

  end



  # Put all filenames into array.
  currentOrderArray.append(filename)

end


# Set filenames by bookOrder
# Remove order numbers from name (XX--)
# Find in bookOrder.yaml
# Change filenames to order in bookOrder.yaml
for bookFile in currentOrderArray do
  ## Reset order file naming
  if bookFile.match(/\d\d[-][-]/) then
    orderResetName = bookFile.sub(/\d\d[-][-]/, '')
    File.rename(book_dir+bookFile, book_dir+orderResetName)
  end
end

puts "Resetting names..."
## Load in order
file = File.open(data_dir+"bookOrder.yaml", "r+")
bookOrderYaml = YAML.load(File.read(data_dir+"bookOrder.yaml"))
file.close

# For every book in order.yaml
bookOrderYaml.each_with_index do |item, index|

  # Find and rename the corresponding file in _books/
  setOrder = index + 1

  if setOrder < 10 then
    string = setOrder.to_s
    setOrder = "0"+string
  end

  setOrder = setOrder.to_s

  File.rename(book_dir+item, book_dir+setOrder+"--"+item)
end
puts "Set book order"

