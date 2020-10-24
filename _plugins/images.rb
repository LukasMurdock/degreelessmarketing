require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'json'
require 'httparty'
require "open-uri"
require "httparty"
# Retrieve your user id and api key from the Dashboard
auth = { username: '3e4fd231-3dba-4676-9df1-c3d54122fe83', password: '63e05c9f-083f-4d71-991c-e9e8f2308cad' }

html = "<div><span class='headerCaption'>Marketing Ideas</span><h1>Decoy Pricing</h1><p>Raise the perceptual value of your products by introducing a decoy product at a similar price but different value.</p></div>"

css = ".headerCaption {
  color: #DD3532;
  font-weight: 600;
  line-height: 1.6;
  font-size: 32px;
}

h1 {
  font-size: 76px;
  display: block;
  margin: 0;
  padding: 0;
  margin-bottom: 10px;
}

p {
  font-size: 44spx;
  margin: 0;
  padding: 0;
  display: block;
  font-family: sans-serif;
  font-weight: normal;
  font-style: normal;
  line-height: 1.6;
  color: #4A5568;
  width: 900px;
}

div {
  padding: 100px;
  color: black;
  font-size: 38px;
  width: 1200px;
  height: 700px;
  font-family: 'sans-serif';
  font-weight: bold;
  background-color: white;
  display: block;
  box-sizing: border-box;
}"

# image = HTTParty.post("https://hcti.io/v1/image",
#                       body: { html: html, css: css },
#                       basic_auth: auth)

response = {"url"=>"https://hcti.io/v1/image/43589391-c4aa-4af9-a81b-63daf4c482e6"}

# => {"url"=>"https://hcti.io/v1/image/bde7d5bf-f7bb-49d9-b931-74e5512b8738"}


root_dir =  File.expand_path(".", Dir.pwd)
book_dir = File.join(root_dir, "_posts/")
image_dir = File.join(root_dir, "assets/images/posts/")

# SHIT BREAKS BELOW HERE 


check_array = []
currentOrderArray = []
Dir.foreach(book_dir) do |filename|
    next if filename == '.' or filename == '..'
    # Do work on the remaining files & directories
    fileRead = YAML.load_file(book_dir+filename)

    unless fileRead.include? 'image' then
      puts "Getting Image for "+filename
        # p filename

        thing = YAML.load_file(book_dir+filename)
        html = "<div><span class='headerCaption'>Marketing Ideas</span><h1>#{thing["title"]}</h1><p>#{thing["description"]}</p></div>"


        response = HTTParty.post("https://hcti.io/v1/image",
                              body: { html: html, css: css },
                              basic_auth: auth)

        # api_url = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + fileRead["isbn"].to_s + "+&fields=items(volumeInfo/imageLinks/thumbnail,volumeInfo/industryIdentifiers/identifier,volumeInfo/categories)+&maxResults=40"
        
        # begin
        #     response = HTTParty.get(api_url)
        #   rescue HTTParty::Error
        #     # don´t do anything / whatever
        #   rescue StandardError
        #     # rescue instances of StandardError,
        #     # i.e. Timeout::Error, SocketError etc
        # end

            unless response.empty? then
              unless response["url"].nil? then

                image_url = response["url"]+".jpg"
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
          
                insert_array = ["image", "'/assets/images/posts/'+#{imageName+'.jpg'}"]
          
                bookArray.insert(3, insert_array)
          
                bookYaml = bookArray.to_h.to_yaml + "\n---\n" + bookText
                
                File.open(book_dir+filename, "w") {|f| f.write(bookYaml)}
              end
            end
    end



end


