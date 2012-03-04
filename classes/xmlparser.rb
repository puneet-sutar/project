require "rubygems"
require "xmlsimple"
class Parser
  attr_accessor :hash
  def initialize
    self.hash=XmlSimlpe.new
  end
  def in(file)
    self.hash.xml_in(file)
  end
  def in(file)
    self.hash.xml_in(file)
  end
end
  
