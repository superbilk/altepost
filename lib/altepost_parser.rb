class AltepostParser
  require 'nokogiri'
  require 'open-uri'

  def initialize(week = nil)
    switch_week(week)
  end

  def switch_week(week = nil)
    return false if week == @week && !week.nil? && !@week.nil?
    validate_week(week) unless week.nil?
    @week = week.nil? ? date2week(Date.today) : week
    @url = "http://altepost.sipgate.net/?kw=#{@week}"
    @content = Nokogiri::HTML(open(@url))
  end

  def dishes_of_the_day(date)
    validate_date(date)
    update_week(date)
    dishes = []
    articles = @content.xpath("/html/body/div[1]/div[4]/div/article[descendant::header[text()[contains(.,'#{date}')]]]/div/div")

    unless articles.empty?
      articles.each do |article|
        metadata = article['class'].to_s.split(' ').drop(1)
        dish = {}
        dish[:meal_id] = metadata.pop
        dish[:food_type] = metadata.pop
        dish[:name] = article.at_xpath("./div[@class='text']/span/text()").to_s
        dish[:date] = date
        add_image(dish)
        dishes << dish
      end
    end

    dishes
  end

  def dishes_of_today
    dishes_of_the_day(Date.today.strftime('%d.%m.%Y'))
  end

  private

  def update_week(date)
    return false if @week == date2week(date)
    switch_week(date2week(date))
  end

  def date2week(date)
    "#{Date.parse(date.to_s).strftime('%V')}/#{Date.parse(date.to_s).cwyear}"
  end

  def add_image(dish)
    url = "http://altepost.sipgate.net/showPic.php?meal=#{dish[:meal_id][4..-1]}&pic=image.jpg"

    begin
      file = Tempfile.new([dish[:meal_id], '.jpg'], :encoding => 'ascii-8bit')
      file.write open(url).read
      dish[:image_file] = file
    rescue OpenURI::HTTPError => e
      url = nil
      dish[:image_file] = nil
    end
    dish[:image_url] = url
  end

  def validate_week(week)
    raise DateFormatException, "use WW/YYYY, not #{week}" unless /\A[0-9]{2}\/20[0-9]{2}\z/ =~ week
  end

  def validate_date(date)
    raise DateFormatException, "use DD.MM.YYYY, not #{date}" unless /\A[0-9]{2}\.[0-9]{2}\.20[0-9]{2}\z/ =~ date
  end
end #class

class DateFormatException < Exception
end
