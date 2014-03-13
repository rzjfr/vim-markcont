# http://daringfireball.net/projects/markdown/syntax#header

from sys import argv
import re

try:
    with open(argv[1], 'r') as f:
        text = f.read()
except IOError:
    text = ""

junks = re.compile(r'[ #]+$', re.MULTILINE)

headers = re.compile(r'(^[#]{1,6})(.+)', re.MULTILINE)


for i in re.finditer(headers, text):
    line_number = text.count('\n', 0, i.start()) + 1
    indent = len(i.group(1))
    tag = re.sub(junks, '', i.group(2)).lstrip()
    print " "*indent*4, "- [%s](#%s)" % (tag, tag.lower().replace(' ', '-'))
