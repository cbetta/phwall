class Doodle
  FILENAME = '/tmp/doodle.xls'.freeze
  DAYS = ["Tue 4", "Wed 5", "Thu 6"].freeze

  def initialize url
    @url = url
  end

  def read
    download
    parse
    current
  end

  private

  def download
    File.open(FILENAME, "wb") do |f|
      f.write HTTParty.get(@url).parsed_response
    end
  end

  def parse
    book = Spreadsheet.open FILENAME
    sheet = book.worksheet 0
    times = sheet.row(5)
    @startups = []
    sheet.each 6 do |row|
      index = row.index('OK')
      next if index.nil?
      @startups << {
        name: row[0],
        time: times[index],
        date: index > 35 ? DAYS[2] : (index > 18 ? DAYS[1] : DAYS[0])
      }
    end
  end

  def current
    @startups.select do |startup|
      startup[:date] == today
    end.sort do |a,b|
      Time.parse(a[:time] ) <=> Time.parse(b[:time])
    end
  end

  def today
    @today ||= begin
      day = Time.now.strftime("%b %e")
      DAYS.include?(day) ? day : DAYS[0]
    end
  end
end
