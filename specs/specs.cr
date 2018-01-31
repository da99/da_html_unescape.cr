
require "da_spec"
require "da_html_escape"
require "../src/da_html_unescape"

extend DA_SPEC

TEST_ENTITIES_SET = [
  ["sub",     0x2282,   "⊂" ],
  ["sup",     0x2283,   "⊃" ],
  ["nsub",    0x2284,   "⊄" ],
  ["subE",    0x2ac5,   "⫅" ],
  ["sube",    0x2286,   "⊆" ],
  ["supE",    0x2ac6,   "⫆" ],
  ["supe",    0x2287,   "⊇" ],
  ["bottom",  0x22a5,   "⊥" ],
  ["perp",    0x22a5,   "⊥" ],
  ["models",  0x22a7,   "⊧" ],
  ["vDash",   0x22a8,   "⊨" ],
  ["Vdash",   0x22a9,  "⊩" ],
  ["Vvdash",  0x22aa,  "⊪" ],
  ["nvdash",  0x22ac,  "⊬" ],
  ["nvDash",  0x22ad,  "⊭" ],
  ["nVdash",  0x22ae,  "⊮" ],
  ["nsube",   0x2288,  "⊈" ],
  ["nsupe",   0x2289,  "⊉" ],
  ["subnE",   0x2acb,  "⫋" ],
  ["subne",   0x228a,  "⊊" ],
  # ["vsubnE",  0x228a,  "⫋︀" ],
  # ["vsubne",  0x228a,  "⊊" ],
  ["nsc",     0x2281,  "⊁" ],
  ["nsup",    0x2285,  "⊅" ]
  # ["b.alpha", 0x03b1,  "α" ],
  # ["b.beta",  0x03b2,  "β" ],
  # ["b.chi",   0x03c7,  "χ" ],
  # ["b.Delta", 0x0394,  "Δ" ],
]

macro assert_unescape(expected, input)
  expected = {{expected}}
  actual   = {{input}}
  if actual.is_a? String
    assert DA_HTML_UNESCAPE.unescape_once(actual) == expected
  else
    assert actual == expected
  end
end

macro assert_unescape!(expected, input)
  expected = {{expected}}
  actual   = {{input}}
  if actual.is_a? String
    assert( DA_HTML_UNESCAPE.unescape!(actual) == expected)
  else
    assert( actual == expected)
  end
end

require "./unescape_once"
require "./unescape_bang"

