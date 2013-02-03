require 'rubygems'
require 'origami'     # gem install nokogiri
require 'json'        # gem install json

include Origami

begin
  target = (ARGV.empty?) ? STDIN : ARGV.shift
  pdf = PDF.read(target, :verbosity => Parser::VERBOSE_QUIET)

  info = {}
  if pdf.has_metadata?
    metadata = pdf.get_metadata
    metadata.each_pair do |name, item|
      info[name] = item
    end
  end
  STDOUT.puts JSON.pretty_generate(info)

rescue SystemExit
rescue Exception => e
  STDERR.puts "#{e.class}: #{e.message}"
  exit 1
end

