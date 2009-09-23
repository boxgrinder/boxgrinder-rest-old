# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def bread_crumb
    s = "<ul class='breadcrumb'><li class='first'><a href='/'>Home</a></li>"
    url = request.path.split('?')  #remove extra query string parameters
    levels = url[0].split('/') #break up url into different levels
    levels.each_with_index do |level, index|
      unless level.blank?
        #if
          #(level == levels[levels.size-2] && levels[levels.size-1].to_i > 0)
         # s += "<li class='subsequent'>#{level.gsub(/_/, ' ')}</li>\n" # unless level.to_i > 0
        #else
          link = "/"
          i = 1
          while i <= index
            link += "#{levels[i]}/"
            i+=1
          end
          s += "<li class='subsequent'><a href=\"#{link.gsub(/\/$/, '')}\">#{level.gsub(/_/, ' ')}</a></li>\n"
       # end
      end
    end
    s+="</ul>"
  end

  def parent_layout(layout)
    @content_for_layout = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def valid_format?
    formats = [ "json", "yaml", "xml" ]

    return formats.include?( params[:format] )
  end

  def api_name
    "Grape"
  end

  def api_version
    "1.0.0"
  end

end
