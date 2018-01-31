
require "myhtml"

module DA_HTML_UNESCAPE

  extend self

  CNTRL_CHAR_REGEX = /[^\P{C}\n]+/
  DOUBLE_SPACE     = "  "
  SPACE            = ' '
  TAB              = '\t'

  def clean(s)
    s.gsub(TAB, DOUBLE_SPACE).gsub(CNTRL_CHAR_REGEX, SPACE)
  end # === def clean

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

