require 'curb'
require 'nokogiri'
require 'csv'

category_page_url = ARGV[0]
result_file_name = ARGV[1]

unless ARGV.length == 2
  abort("Wrong program arguments")
end

$csv = CSV.open(result_file_name, "w")
$csv << ["Title", "Price", "Image", "Delivery Time", "Product Code"]

def parse(category_page_url)
  http = Curl.post(category_page_url)
  category_page_html = Nokogiri::HTML(http.body_str) 
  site_url = "https://www.viovet.co.uk"

  category_page_html.xpath("//ul[contains(@class, 'families-list')]/li/a/@href").each do |page_url|
  	#adding web-site url to page url to get a full address
  	product_page_url = site_url.to_s + page_url.to_s.strip
  	
  	parse_page(product_page_url)
  end
end 

def parse_page(product_page_url)
  http = Curl.post(product_page_url)
  product_page_html = Nokogiri::HTML(http.body_str)
  title = product_page_html.xpath("//h1[contains(@id,'product_family_heading')]").text

  product_page_html.xpath("//ul[contains(@id, 'product_listing')]/li[contains(@class, 'product')]").each do |node|
    product = create_product(node)

    #concatenate title and weight to get a full name of a product
    product[0] = title.to_s + " - " + product[0]

    $csv << product
  end
end

#return an array with the product characteristics
def create_product(node)
  weight_title = node.xpath("div[contains(@class, '_1')]/div[contains(@class, 'title')]").text

  #delete unnecessary quotes and spaces
  weight_title = weight_title[1..-2].strip

  price = node.xpath("div[contains(@class, '_2')]/div[contains(@class, 'rrp')]/span[contains(@class, 'rrp_saving')]").text
  
  #delete a pound sign before value
  price = price[1..-1]

  image = node.xpath("div[contains(@class, '_1')]/ul/li[1]/a/@data-thumbnail").to_s
  
  #check if current type of product has a picture
  #if no use the default product picture
  #else just leave an empty string
  if image == ""
  	image = node.xpath("//img[contains(@class, '_img_zoom')]/@src").to_s
  	image = "http:" + image if image != ""
  else
  	image = "http:" + image.to_s
  end

  delivery_time = node.xpath("div[contains(@class, '_1')]/strong[contains(@class, 'in-stock')]").text
  
  #check if supplier is able to advise delivery date
  #if no then delivery_time will keep info about it
  if delivery_time == ""
    delivery_time = node.xpath("div[contains(@class, '_1')]/strong[contains(@class, 'out-stock')]/text()").text
  end

  #delete unnecessary quotes and spaces
  delivery_time = delivery_time[1..-2].strip

  product_code = node.xpath("div[contains(@class, '_1')]/ul/li/a[contains(@class, 'item-code')]/strong").text
  
  return [weight_title, price, image, delivery_time, product_code]
end

parse(category_page_url)
$csv.close
