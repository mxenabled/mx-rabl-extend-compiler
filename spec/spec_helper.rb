# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'rake'
Bundler.require(:default, :development, :test)

def capture_stdout
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end
