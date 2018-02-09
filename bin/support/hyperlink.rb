#!/usr/bin/env ruby
require "json"

file = ARGV[0]
link_dictionary = ARGV[1]
domain = ARGV[2]

#NB: Hyperlink only hyperlinks the first occurrence of a key within a given unit of header content
def hyperlink(file, domain, link_dictionary)

  link_dictionary = JSON.parse(link_dictionary)
  original_file_values = JSON.parse(File.read(file))
  transformed_file_values = {}

  original_file_values.each do |header, content|
    transformed_content = content
    link_dictionary.each do |term, link_address|
      next if file.match(/#{link_address}\.json$/)
      # only hyperlink the first occurrence of a given within a section
      transformed_content = transformed_content.sub(
        /(^|\s|\()#{term}($|\.|\)|\s)/, # make the term is preceded+followed by a space, period, \n etc.
        "\\1[#{term}](#{domain}#{link_address})\\2"
      )
    end
    transformed_file_values[header] = transformed_content
  end
  return transformed_file_values
end

puts hyperlink(file, domain, link_dictionary).to_json


