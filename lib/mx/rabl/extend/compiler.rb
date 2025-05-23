# frozen_string_literal: true

require 'rabl'
require 'mx/rabl/extend/compiler/version'

module Mx
  module Rabl
    module Extend
      module Compiler
        if defined?(Rake)
          ::Dir[::File.join(::File.dirname(__FILE__), '..', '..', '..', 'tasks', '**', '*.rake')].each do |rake_file|
            load rake_file
          end
        end
      end
    end
  end
end
