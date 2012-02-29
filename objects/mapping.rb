
require 'Qt4'
require "rubygems"
require "xmlsimple"

$objects=XmlSimple.xml_in("obj.xml")
class MyWidget < Qt::Widget
 
  
  def initialize(parent = nil)
    super()
    @listWidget_2 = Qt::ListWidget.new(window)
    @listWidget_2.objectName = "listWidget_2"
    @listWidget_2.geometry = Qt::Rect.new(440, 10, 181, 411)
    @textBrowser = Qt::TextBrowser.new(window)
    @textBrowser.objectName = "textBrowser"
    @textBrowser.geometry = Qt::Rect.new(650, 10, 256, 192)
    @gridLayoutWidget = Qt::Widget.new(window)
    @gridLayoutWidget.objectName = "gridLayoutWidget"
    @gridLayoutWidget.geometry = Qt::Rect.new(0, 10, 421, 411)
    @gridLayout = Qt::GridLayout.new(@gridLayoutWidget)
    @gridLayout.objectName = "gridLayout"
    @gridLayout.sizeConstraint = Qt::Layout::SetFixedSize
    @gridLayout.setContentsMargins(0, 0, 0, 0)
    

    
    i=0;
    @fields={}
    
    $objects['object'].each do |object| 
        objname=object['name'][0]["content"]
        object['attr'].each do |attr|
            if attr["f_key"]=="false"
                attr["A"]=Qt::LineEdit.new(@gridLayoutWidget)
                attr["A"].text="#{objname}:#{attr["name"]}"
                attr["B"]=Qt::LineEdit.new(@gridLayoutWidget)
                @gridLayout.addWidget(attr["A"], i, 0, 1, 1) 
                @gridLayout.addWidget(attr["B"], i, 1, 1, 1)    
                i=i+1
            end
        end
    end   
end
end
app = Qt::Application.new(ARGV)

widget = MyWidget.new()
widget.show()

app.exec()
#puts 'hello'
