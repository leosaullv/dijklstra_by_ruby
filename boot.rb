

lib_dir = File.join(File.dirname(__FILE__), "lib")
Dir.entries(lib_dir).each {|file| require "#{lib_dir}/#{file}" if file.match(".rb$")}
