require 'pry'

Dir.glob(File.join(__dir__, '../lib/**/*.rb'))
  .each { |file| require file }
