class AltepostParser
  require 'nokogiri'
  require 'open-uri'

  def initialize
    @url = "http://altepost.sipgate.net"
    @content ||= Nokogiri::HTML(open(@url))
  end

  def today
    dishes = []

    articles = @content.xpath("/html/body/div[1]/div[4]/div/article[descendant::a[@name='today']]/div/div")
    unless articles.empty?
      date = Date.parse(@content.xpath("/html/body/div[1]/div[4]/div/article[descendant::a[@name='today']]/header/text()").to_s.strip!)

      articles.each do |article|
        dish = {}
        dish[:id] = article['class'].to_s.split(' ').last
        dish[:food_type] = article['class'].to_s.split(' ')[1]
        dish[:name] = article.xpath(".//div[@class='text']/span/text()").to_s
        dish[:date] = date
        dish[:calories] = nil
        dishes << dish
      end
    end
    dishes
  end
end #class


altepost = AltepostParser.new
puts altepost.today
