require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'json'
require 'httparty'
require "open-uri"
require "down"
require "fileutils"

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
  # p "***********BEFORE************"
  # p dataYaml
  # p "***********BEFORE************"

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

    p "TITLE: #{item["title"].nil?}"
    # Account for different yaml formats
    unless item["title"].nil? then
      p "IMAGE: #{item["image"].include? "http"}"
      # Check for images not locally hosted
      if item["image"].include? "http" then
        image_title = item["title"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        image_url = item["image"]
        file_ext = File.extname(image_url) 
        p "Downloading #{image_title+file_ext}"


        # puts image_dir
        # puts image_title
        # puts file_ext

        newName = "/assets/images/resources/" + image_title + file_ext
        item["image"] = newName
  
        # File.open(data_dir+filename, "w") {|f| f.write(dataYaml.to_yaml)}

        # Down.download(image_url, destination: "./")

        # tempfile = Down.download(image_url)
        # FileUtils.mv(tempfile.path, image_dir+image_title+file_ext)

      end
    else
      # Check for images not locally hosted within guides.yaml
        # p item.values[0][1]
        for type in item.values[0] do
          if type.values[3].include? "http" then
            image_title = type.values[0].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
            image_url = type.values[3]
            file_ext = File.extname(image_url) 
            p "Downloading #{image_url} for #{type.values[0]}"
            # p "TYPE: #{type["image"]}"
            newName = "/assets/images/resources/" + image_title + file_ext
            type["image"] = newName
            # p "TYPE: #{type["image"]}"
    
          p "Rewriting #{filename} with #{type.values[0]}"

          p "OPEN FILE: #{data_dir+filename}"

          File.open(data_dir+filename, "w") {|f| f.write(dataYaml.to_yaml)}

          # URI.open(image_url) do |image|
          #   File.open(image_dir+image_title+file_ext, "wb") do |file|
          # file.write(image.read)
          # end
          Down.download(image_url, destination: "./")

          tempfile = Down.download(image_url)
          FileUtils.mv(tempfile.path, image_dir+image_title+file_ext)
        # end
      end
    end

    end
    # p item.values[0][0]["image"]
  end
end


# file = File.open(data_dir+filename, "r+")
# dataYaml = YAML.load(File.read(data_dir+filename))
# dataMarkdown = File.read(data_dir+filename)
# file.close

# dataYaml = dataYaml.to_yaml.gsub("---\n", "")

# p "***********AFTER************"
# p dataYaml
# p "***********AFTER************"



# File.open(data_dir+filename, "w") {|f| f.write(dataYaml.to_yaml)}

  # p dataYaml[0].key("image")
  # p dataYaml.key("image")

  # Get all image urls from resource guides
  # for category in dataYaml do
  #   p category
  #   p "----------------"
  # end

  # Find image index in resource
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