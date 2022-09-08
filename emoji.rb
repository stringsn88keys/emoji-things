require 'nokogiri'

class Emoji
  def initialize(filename=nil)
    @shortcuts={}
    File.open(filename||File.join(__dir__, 'Text Substitutions.plist')) do |f|
      Nokogiri::XML(f).xpath("//dict").each do |node|
        phrase=node.xpath('./string[1]').text
        shortcut=node.xpath('./string[2]').text
        @shortcuts[shortcut]=phrase
      end
    end
  end

  def at(phrase)
    @shortcuts[phrase.to_s.strip] || @shortcuts.keys
  end
end


def pbcopy(input)
  str = input.to_s
  IO.popen('pbcopy', 'w') { |f| f << str }
  str
end
pbcopy(Emoji.new.at(ARGV[0]))
