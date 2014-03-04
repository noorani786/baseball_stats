# require 'CSV'

# module CsvParseable
#   def parse(file_path, &block)
#     if File.ext(file_path) != ".csv"
#     CSV.foreach(file_path, {headers: true, header_converters: :symbol}, &block)
#   end
# end