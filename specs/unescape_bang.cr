
require "html"

    # %3C
    BRACKET = "
      < &lt &lt; &LT &LT; &amp;#60 &#60 &#060 &#0060
      &#00060 &#000060 &#0000060 &#60; &#060; &#0060; &#00060;
      &#000060; &#0000060; &#x3c &#x03c &#x003c &#x0003c &#x00003c
      &#x000003c &#x3c; &amp;#x03c; &#x003c; &#x0003c; &#x00003c;
      &#x000003c; &#X3c &#X03c &#X003c &#X0003c &#X00003c &#X000003c
      &#X3c; &#X03c; &#X003c; &amp;amp;#X0003c; &#X00003c; &#X000003c;
      &#x3C &#x03C &#x003C &#x0003C &#x00003C &#x000003C &#x3C; &#x03C;
      &#x003C; &#x0003C; &#x00003C; &#x000003C; &#X3C &#X03C
      &#X003C &#X0003C &#X00003C &#X000003C &#X3C; &#X03C; &#X003C; &#X0003C;
      &#X00003C; &#X000003C; \x3c \x3C \u003c \u003C
    "

describe ":unescape!" do

  it "should decode apos entity" do
    assert_unescape! "é'", "&eacute;&apos;"
  end

  it "should not decode dotted entity" do
    assert_unescape! "&b.Theta;", "&b.Theta;"
  end

  {% for x in TEST_ENTITIES_SET %}
    it "should unescape &{{x.first.id}}; => {{x.last.id}}" do
      ent     = {{x.first}}
      code    = {{x[1]}}
      decoded = {{x.last}}
      assert_unescape! decoded, "&#x#{code.to_s(16)};"
      assert_unescape! decoded, "&#{ent};"
    end
  {% end %}

  {% for x in TEST_ENTITIES_SET %}
    it "should round trip preferred entity: &{{x.first.id}}; => {{x.last.id}}" do
      name    = {{x.first}}
      code    = {{x[1]}}
      decoded = {{x.last}}
      assert "&#x#{code.to_s(16)};" == DA_HTML_ESCAPE.escape(DA_HTML_UNESCAPE.unescape!("&amp;amp;amp;#{name};") || "")
      assert decoded == DA_HTML_UNESCAPE.unescape!( DA_HTML_ESCAPE.escape(decoded) )
    end
  {% end %}

  it "should round trip entity: &nsubE; => ⫅̸" do
    ent     = "&nsubE;"
    code    = [0x2ac5.to_i, 0x0338.to_i]
    decoded = "⫅̸"
    assert_unescape! decoded, DA_HTML_ESCAPE.escape(decoded)
  end # === it "should round trip preferred entity: &nsubE; => "⫅̸""

  it "should round trip entity: &nsupE; => ⫆̸" do
    ent     = "&nsupE;"
    code    = [0x2ac6.to_i, 0x0338.to_i]
    decoded = "⫆̸"
    assert_unescape! decoded, DA_HTML_ESCAPE.escape(decoded)
  end # === it "should round trip preferred entity: &nsupE; => ⫆̸"

  it "should round trip entity: &vsubnE;" do
    ent     = "&vsubnE;"
    code    = [0x2acb.to_i, 0xfe00.to_i]
    decoded = "⫋︀"
    assert_unescape! decoded, DA_HTML_ESCAPE.escape(decoded)
  end # === it "should round trip preferred entity: &vsubnE;"

  it "should round trip entity: &vsubne;" do
    ent     = "&vsubne;"
    code    = [0x228a.to_i, 0xfe00.to_i]
    decoded = "⊊︀"
    assert_unescape! decoded, DA_HTML_ESCAPE.escape(decoded)
  end # === it "should round trip preferred entity: &vsubnE;"

  it "should decode apos entity" do
    assert_unescape! "é'", "&eacute;&apos;"
  end

  # This does not apply to HTML:
  # it "should decode dotted entity" do
  #   assert_unescape! "Θ", "&b.Theta;"
  # end

  it "should decode basic entities" do
    assert_unescape! "&", "&amp;"
    assert_unescape! "<", "&lt;"
    assert_unescape! "\"", "&quot;"
  end

  it "should decode extended named entities" do
    assert_unescape! "±", "&plusmn;"
    assert_unescape! "ð", "&eth;"
    assert_unescape! "Œ", "&OElig;"
    assert_unescape! "œ", "&oelig;"
  end

  it "should decode decimal entities" do
    assert_unescape! "“", "&#8220;"
    assert_unescape! "…", "&#8230;"
    assert_unescape! " ", "&#32;"
  end

  it "should decode hexadecimal entities" do
    assert_unescape! "−", "&#x2212;"
    assert_unescape! "—", "&#x2014;"
    assert_unescape! "`", "&#x0060;"
    assert_unescape! "`", "&#x60;"
  end

  it "should not mutate string being decoded" do
    original = "&amp;lt;&#163;"
    input = original.dup
    DA_HTML_UNESCAPE.unescape!(input)

    assert input == original
  end

  it "should decode text with mix of entities" do
    # Just a random headline - I needed something with accented letters.
    assert_unescape!(
      "Le tabac pourrait bientôt être banni dans tous les lieux publics en France",
      "Le tabac pourrait bient&ocirc;t &#234;tre banni dans tous les lieux publics en France"
    )
    assert_unescape!(
      "\"bientôt\" & 文字",
      "&quot;bient&ocirc;t&quot; &amp; &#25991;&#x5b57;"
    )
  end

  it "should decode empty string" do
    assert_unescape! "", ""
  end

  it "should skip unknown entity" do
    assert_unescape! "&bogus;", "&bogus;"
  end

  it "should decode double encoded entity" do
    assert_unescape! "&", "&amp;amp;amp;amp;amp;"
  end

  it "should decode null character to replacement character: \\u0000" do
    encoded = "&amp;amp;#x0;"
    decoded = DA_HTML_UNESCAPE.unescape!(encoded) || "error"
    assert(decoded.codepoints == [65533])
  end

  it "should decode hexadecimal range as a space: 1 - 31 (except 9 - tab, 10 - line feed)" do
    (1..31).each do |codepoint|
      next if codepoint == 9
      next if codepoint == 10
      assert_unescape! " ", "&amp;amp;amp;\#x#{codepoint.to_s(16)};"
    end
  end

  it "should decode codepoint 9 as a tab as 2 spaces" do
    assert_unescape! "  ", "&amp;amp;amp;\#x#{9.to_s(16)};"
  end

  it "should decode codepoint 10 as a new line" do
    assert_unescape! "\n", "&amp;amp;amp;\#x#{10.to_s(16)};"
  end

  it "should decode codepoint 127 as a space" do
    assert_unescape! " ", "&amp;amp;amp;\#x#{127.to_s(16)};"
  end

  it "should decode full hexadecimal range: 32 - 126" do
    (32..126).each do |codepoint|
      assert_unescape! [codepoint.chr].join, "&amp;amp;amp;\#x#{codepoint.to_s(16)};"
    end
  end

  # Reported by Dallas DeVries and Johan Duflost
  it "should decode named entities reported as missing in 3 0 1" do
    assert_unescape!  [178.chr].join, "&sup2;"
    assert_unescape! [8226.chr].join, "&bull;"
    assert_unescape!  [948.chr].join, "&delta;"
  end

  it "should decode only first element in masked entities first" do
    assert_unescape! "ഒ", "&amp;#3346;"
  end

  it "should decode invalid brackets" do
    # %3C 
    expected = DA_HTML_UNESCAPE.unescape!( BRACKET )
    if expected
      expected = expected.split.uniq.join
    end
    assert(expected == "<")
  end # === it "should decode invalid brackets"

end # === desc ":unescape"

describe ":unescape! string encodings" do

  it "should decode ascii to utf8" do
    s = "&#x3c;&eacute;lan&#x3e;"

    assert_unescape! "<élan>", s
    actual = DA_HTML_UNESCAPE.unescape!(s)
    assert actual != nil
    if actual
      assert(actual.valid_encoding? == true)
    end
  end

  it "should decode utf8 to utf8" do
    s = "&#x3c;&eacute;lan&#x3e;"
    assert(s.valid_encoding? == true)

    actual = DA_HTML_UNESCAPE.unescape!(s)
    assert_unescape! "<élan>", s
    assert actual != nil
    if actual
      assert(actual.valid_encoding? == true)
    end
  end

  it "should decode other encoding to utf8" do
    slice = Slice.new(2, 0_u8)
    slice[0] = 186_u8
    slice[1] = 195_u8
    str = String.new(slice, "GB2312")

    origin = "好"
    encoded = DA_HTML_ESCAPE.escape(origin)

    assert DA_HTML_UNESCAPE.unescape!(encoded) == str

    actual = DA_HTML_UNESCAPE.unescape!(encoded)
    assert(actual != nil)
    if actual
      assert(actual.valid_encoding? == true)
    end
  end

end # === desc ":unescape string encodings"


describe ":unescape!" do # === Imported from Mu_Clean.

  it "un-escapes until it can no longer escape." do
    str = "Hello < Hello <"
    assert(
      DA_HTML_UNESCAPE.unescape!(
        3.times.reduce(str) { |acc, i| HTML.escape(acc) }
      ) == str
    )
  end

  it "un-escapes escaped text mixed with HTML" do
    s = "<p>Hi&amp;</p>";
    assert(DA_HTML_UNESCAPE.unescape!(s) == "<p>Hi&</p>")
  end

  hello_with_special_chars = "Hello & World ©®∆"
  it "un-escapes special chars: \"#{hello_with_special_chars}\"" do
    s = "Hello &amp; World &#169;&#174;&#8710;"
    assert(DA_HTML_UNESCAPE.unescape!(s) == hello_with_special_chars)
  end

  it "un-escapes all 70 different combos of '<'" do
    actual = (DA_HTML_UNESCAPE.unescape!(BRACKET) || "").split.uniq.join(" ")
    assert(actual == "<")
  end

end # === describe :un_e
