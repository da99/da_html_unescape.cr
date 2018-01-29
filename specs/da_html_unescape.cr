
require "../src/unescape"
macro assert_unescape(expected, input)
  expected = {{expected}}
  actual   = {{input}}
  if actual.is_a? String
    ( DA_HTML_ESCAPE.unescape_once(actual) ).should eq(expected)
  else
    actual.should eq(expected)
  end
end

macro assert_unescape!(expected, input)
  expected = {{expected}}
  actual   = {{input}}
  if actual.is_a? String
    ( DA_HTML_ESCAPE.unescape!(actual) ).should eq(expected)
  else
    actual.should eq(expected)
  end
end

require "./unescape_once"
require "./unescape_bang"
