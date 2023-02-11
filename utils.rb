class String
  def sanitize_filename
    self.strip.gsub(/[^0-9A-Za-z.\-]/, '_')
  end
end

class EduList

  def initialize(name)
    @name = name
  end

  def get
    result = []
    File.open(@name,'r').each_line do |l|
      x = l.encode('UTF-8',:invalid => :replace).gsub(/\s+/,'')
      x = x.prepend("https://") unless  x.start_with?('http')
      result << x
    end
    result
  end
end