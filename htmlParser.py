#!/usr/bin/env python

__author__ = 'pbelmann'

from bs4 import BeautifulSoup
import argparse
import codecs

parser = argparse.ArgumentParser(description='Parses HTML')
parser.add_argument('--input', dest="input", required=True,
                    help='input html path')
parser.add_argument('--output', dest='output', required=True,
                    help='output html path')
parser.add_argument('--krona', dest='krona', required=True,
                    help='path to krona.js')
args = parser.parse_args()

input = args.input
output = args.output
krona = args.krona

with codecs.open(input, "r", encoding='utf-8') as htmlFile:
    html=htmlFile.read()

soup = BeautifulSoup(html, from_encoding="UTF-8")

for script in soup.findAll('script',{"src":True}):
    src = script['src']
    del(script['src'])
    with codecs.open(krona, "r", encoding="utf-8") as sourceFile:
        source = sourceFile.read()
        source = source.replace("</script>",'')
        script.append(source)

new_tag = soup.new_tag("script", type=["text/javascript"])
soup.html.head.append(new_tag)
output_html = str(soup)
with codecs.open(output, "w+") as file:
    file.write(output_html)


