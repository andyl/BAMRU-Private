module JqmHelper

  def jqm_back_button(page_id)
    link_to("Home", "/jqm", "data-icon" => "home", "data-direction" => "reverse") unless page_id == "home"
  end

  def jqm_paging_nav(page_id)
    return "" unless page_id == "send_page"
    <<-ERB
    <div data-role="navbar">
      <ul>
        <li><a href="#" id="select_link" data-role="button">Select<span id=select_count></span></a></li>
        <li><a href="#" id="send_link"  data-role="button">Compose</a></li>
      </ul>
    </div>
    ERB
  end

  def page_start(page_id, title = "BAMRU Mobile")
    raw <<-HTML.gsub(' '*6,'')
      <section id="#{page_id}" data-role="page">
        <header data-role="header">
          #{ jqm_back_button(page_id) }
          <h1>#{title}</h1>
          #{ jqm_paging_nav(page_id) }
        </header>
        <div data-role="content">
    HTML
  end

  def page_end
    raw <<-HTML.gsub(' '*6, '')

        </div>
      </section>
    HTML
  end

end