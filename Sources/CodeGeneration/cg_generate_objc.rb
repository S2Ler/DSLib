#!/usr/bin/ruby

require 'optparse'
require 'ostruct'

options = OpenStruct.new

begin
  optionsParser = OptionParser.new

  optionsParser.on_tail("-h", "--help", "Show this message") do
    puts optionsParser
    exit
  end

  optionsParser.on_tail("-v", "--version", "Show version") do
    puts "1.0.1"
    exit
  end

  optionsParser.on("--d Directory", String, "Require directory to run script") do |dir|
      options.dir = dir.chomp
  end

  if ARGV.length < 1
    puts optionsParser
    exit
  end

  optionsParser.parse!(ARGV)
end

def processDir(dir)
  Dir.foreach(dir) { |item|
    full_item_path = File.expand_path(item, dir)
    if File.directory?(full_item_path)
      if !(item =~ /^\./)
        processDir(full_item_path)
      end
    else
      if item =~ /cg.xml$/
        fileName = item.gsub(/.cg.xml$/, "")
        outPathH = File.expand_path("#{fileName}.h", dir)
        outPathM = File.expand_path("#{fileName}.m", dir)

        args = "--i '#{full_item_path}' --t 'ObjectiveC_h.erb' --o '#{outPathH}' --t 'ObjectiveC_m.erb' --o '#{outPathM}'"
        
        isSuccess = system("ruby cg_generate.rb #{args}")
      end
    end
  }


end


puts "Processing dir: #{options.dir}\n"
processDir(options.dir)


