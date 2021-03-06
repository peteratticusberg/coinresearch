#!/usr/bin/env ruby
require('json')

file = ARGV[0]

def camelize(str)
  tokens = str.strip.split(" ")
  titleCaseStr = tokens.reduce { |res, token| res += token.downcase.sub(/^[a-z]/, &:upcase) }
  camelCaseStr = titleCaseStr.sub(/^[A-Z]/, &:downcase)
end

file_content = {}
current_header = nil
header_content = ""
File.readlines(file).each do |line|
  if line =~ /^##[^#]/
    if current_header 
      file_content[current_header] = header_content.strip
      header_content = ""
    end
    current_header = camelize(line.sub(/^##/, "").strip)
  else 
    header_content += line 
  end
end
file_content[current_header] = header_content.strip

puts file_content.to_json


