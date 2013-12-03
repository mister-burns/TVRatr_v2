module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = if column == sort_column && sort_direction == "asc" then
                  "desc"
                else
                  "asc"
                end
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end


  def show_params
    html = "<div style='border:1px red solid;margin:10px;padding:10px;'>"
    html += '<heading>Params:</heading><br/>'
    params.each do |key, value|
      html += "#{key}: #{value}<br/>" if (key != 'authenticity_token' && key != 'utf8')
    end
    html += '</div>'
    return html.html_safe
  end

end
