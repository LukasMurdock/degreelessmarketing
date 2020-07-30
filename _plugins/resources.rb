require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'json'
require 'httparty'
require "open-uri"

# Set directories
root_dir =  File.expand_path(".", Dir.pwd)
# data_dir = File.join(root_dir, "_books/")
data_dir = File.join(root_dir, "_data/")
image_dir = File.join(root_dir, "assets/images/resources/")



# File.open('pie.png', 'wb') do |fo|
#   fo.write open("http://chart.googleapis.com/chart?#{failures_url}").read 
# end

Dir.foreach(data_dir) do |filename|
  next if filename == '.' or filename == '..'


  # Do work on the remaining files & directories
  fileRead = YAML.load_file(data_dir+filename)

  puts "Pulling images for "+filename
  puts filename
  p "#################"
  file = File.open(data_dir+filename, "r+")
  dataYaml = YAML.load(File.read(data_dir+filename))
  dataMarkdown = File.read(data_dir+filename)
  file.close
  p "***********BEFORE************"
  p dataYaml
  p "***********BEFORE************"

  # file = File.open(data_dir+"guides.yaml", "r+")
  # dataYaml = YAML.load(File.read(data_dir+"guides.yaml"))
  # dataMarkdown = File.read(data_dir+"guides.yaml")
  # file.close


  # Assign resource title to images so you can index
  # Pull image hash value
  # Download image with filename as title
  # Replace image yaml with new filename

  # puts dataYaml
for item in dataYaml do
  # p item.class
  unless item.class == String || item.class == Array then

    # Account for different yaml formats
    if item.values[0][0]["title"].nil? then
      # Check for images not locally hosted
      if item["image"].include? "http" then
        image_title = item["title"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        image_url = item["image"]
        file_ext = File.extname(image_url) 

        # puts image_dir
        # puts image_title
        # puts file_ext

        newName = "/assets/images/resources/" + image_title + file_ext
        item["image"] = newName

        # p item.to_a

        # insert_array = ["slug", "#{slug}"]

        # bookArray.insert(3, insert_array)

        # bookYaml = bookArray.to_h.to_yaml + "\n---\n" + bookText
  
        # File.open(book_dir+filename, "w") {|f| f.write(bookYaml)}

        # URI.open(image_url) do |image|
        #   File.open(image_dir+image_title+file_ext, "wb") do |file|
        #     file.write(image.read)
        #   end
        # end

      end
    else
      # Check for images not locally hosted
      if item.values[0][0]["image"].include? "http" then
        p item.values[0][0]["title"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        p item.values[0][0]["image"]
      end
    end
    # p item.values[0][0]["image"]
  end
end

p "***********AFTER************"
p dataYaml
p "***********AFTER************"
  # p dataYaml[0].key("image")
  # p dataYaml.key("image")

  # Get all image urls from resource guides
  # for category in dataYaml do
  #   p category
  #   p "----------------"
  # end

  # Find image index in resource
  p "TITTES"
  # p dataYaml.include?('image')
  # p dataYaml.select {|image| image["image"]}

  # Pull image url and download resource, naming it after the title
  # Replace image yaml with new filename


  # image_url = bookYaml["title"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

  # resourceText = bookMarkdown.partition("\n---\n").last
  # bookArray = bookYaml.to_a

  # insert_array = ["slug", "#{slug}"]

  # bookArray.insert(3, insert_array)

  # bookYaml = bookArray.to_h.to_yaml + "\n---\n" + bookText
  
  # File.open(book_dir+filename, "w") {|f| f.write(bookYaml)}

end