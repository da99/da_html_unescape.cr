
  # myhtml:
  #   github: kostya/myhtml
require "myhtml"

module DA_HTML_ESCAPE

  def unescape_once(source)
    return nil unless source.valid_encoding?
    Myhtml.decode_html_entities(clean(source))
  end

  def unescape!(source : Nil)
    nil
  end # === def unescape!

  def unescape!(source : String)
    str = unescape_once(source)
    return str if str == source
    unescape!(str)
  end # === def unescape

end # === module DA_HTML_ESCAPE

