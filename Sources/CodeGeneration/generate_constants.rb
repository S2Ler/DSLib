#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'date'
require 'erb'
require 'rexml/document'

class ObjStruct
  attr_accessor :name, :instance_name, :constants
end

class ObjConstant
  attr_accessor :type, :name, :value

end


class ConstantsGenerator
  attr_reader :options
  attr_reader :structs

  def initialize(arguments)
    @arguments = arguments

    @options = OpenStruct.new
    @options.templates = []
    @options.outFiles = []
  end

  def run
    parse_options()
    puts "Start at #{DateTime.now}\n"
    process_input_file()

    for i in 0..(@options.outFiles.length-1) do
      outFile = @options.outFiles[i]
      template = @options.templates[i]
      create_out_file_from_template(outFile, template)
    end

    puts "\n Finished at #{DateTime.now}"
  end

  def parse_options
    optionsParser = OptionParser.new

    optionsParser.on_tail("-h", "--help", "Show this message") do
      puts optionsParser
      exit
    end

    optionsParser.on_tail("-v", "--version", "Show version") do
      puts "1.0.0"
      exit
    end

    optionsParser.on("--in InFile", String, "Require one input file to run this script") do |inFile|
      options.inFile = inFile.chomp
    end

    optionsParser.on("--out OutFile", String, String, "Require at least on output file to run this script") do |outfile|
      options.outFiles << outfile.chomp
    end

    optionsParser.on("--t Template", String, "Require at least one template to run this script") do |template|
      options.templates << template.chomp
    end

    optionsParser.parse!(@arguments)
    puts "\n Parser options: #{@options}"
  end

  def process_input_file
    file_name = @options.inFile
    puts "processing file #{file_name}\n"
    @structs = []
    @file_name = ""

    doc = REXML::Document.new(File.open(file_name))

    @file_name = doc.root_node.attribute("module")

    doc.root.each_element("struct") do |struct|
      objStruct = ObjStruct.new
      objStruct.name = struct.attribute("name")
      objStruct.instance_name = struct.attribute("instance_name")
      objStruct.constants = Array.new

      struct.each_element("constant") do |constant|
        objConstant = ObjConstant.new
        objConstant.type = constant.attribute("type")
        objConstant.name = constant.attribute("name")
        objConstant.value = constant.text

        objStruct.constants.push(objConstant)
      end

      @structs.push(objStruct)

    end
  end

  def create_out_file_from_template(outFile, template)
    structs = @structs
    inputFile = @options.inFile

    erb = ERB.new(File.open(template).read)
    erb_result = erb.result(binding)

    File.open(outFile, 'w') {|f| f.write(erb_result)}
  end

end

ConstantsGenerator.new(ARGV).run