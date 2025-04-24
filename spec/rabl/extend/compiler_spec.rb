# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'

describe ::Mx::Rabl::Extend::Compiler do
  uncompiled_path = ::File.join(::File.dirname(__FILE__), '..', '..', 'uncompiled')
  compiled_path = ::File.join(::File.dirname(__FILE__), '..', '..', 'compiled')
  correct_path = ::File.join(::File.dirname(__FILE__), '..', '..', 'correct')

  ::Rabl.configure do |config|
    config.view_paths = [::File.join(::File.dirname(__FILE__), '..', '..', 'compiled')]
  end

  describe 'all' do
    before :all do
      ::FileUtils.cp(::File.join(uncompiled_path, 'app.rabl'), ::File.join(compiled_path, 'app.rabl'))
      ::FileUtils.cp(::File.join(uncompiled_path, 'app_already_compiled.rabl'),
                     ::File.join(compiled_path, 'app_already_compiled.rabl'))
      ::FileUtils.cp(::File.join(uncompiled_path, 'app_multiple.rabl'), ::File.join(compiled_path, 'app_multiple.rabl'))
      ::FileUtils.cp(::File.join(uncompiled_path, 'extend.rabl'), ::File.join(compiled_path, 'extend.rabl'))
      ::FileUtils.cp(::File.join(correct_path, 'app.rabl'), ::File.join(compiled_path, 'app_correct.rabl'))

      ::Rake::Task['rabl:extend:compiler:all'].invoke
    end

    after :all do
      FileUtils.remove_file(::File.join(compiled_path, 'app.rabl'), true)
      FileUtils.remove_file(::File.join(compiled_path, 'app_already_compiled.rabl'), true)
      FileUtils.remove_file(::File.join(compiled_path, 'app_multiple.rabl'), true)
      FileUtils.remove_file(::File.join(compiled_path, 'extend.rabl'), true)
      FileUtils.remove_file(::File.join(compiled_path, 'app_correct.rabl'), true)
    end

    it 'compiles correctly' do
      compiled_contents = ::File.read(::File.join(compiled_path, 'app.rabl'))
      correct_contents = ::File.read(::File.join(correct_path, 'app.rabl'))

      expect(compiled_contents).to eq(correct_contents)
    end

    it 'compiles multiple extends correctly' do
      compiled_contents = ::File.read(::File.join(compiled_path, 'app_multiple.rabl'))
      correct_contents = ::File.read(::File.join(correct_path, 'app_multiple.rabl'))

      expect(compiled_contents).to eq(correct_contents)
    end

    it 'recompiles correctly when changed' do
      compiled_contents = ::File.read(::File.join(compiled_path, 'app_already_compiled.rabl'))
      correct_contents = ::File.read(::File.join(correct_path, 'app_already_compiled.rabl'))

      expect(compiled_contents).to eq(correct_contents)
    end

    it 'recompiles correctly when not changed' do
      compiled_contents = ::File.read(::File.join(compiled_path, 'app_correct.rabl'))
      correct_contents = ::File.read(::File.join(correct_path, 'app.rabl'))

      expect(compiled_contents).to eq(correct_contents)
    end
  end

  describe 'verify' do
    context 'when correct' do
      before :all do
        ::FileUtils.cp(::File.join(uncompiled_path, 'extend.rabl'), ::File.join(compiled_path, 'extend.rabl'))
        ::FileUtils.cp(::File.join(correct_path, 'app.rabl'), ::File.join(compiled_path, 'app_correct.rabl'))
      end

      after :all do
        FileUtils.remove_file(::File.join(compiled_path, 'extend.rabl'), true)
        FileUtils.remove_file(::File.join(compiled_path, 'app_correct.rabl'), true)
      end

      it 'verifies the files in the path' do
        task = ::Rake::Task['rabl:extend:compiler:verify']

        exited = false

        begin
          task.invoke
        rescue SystemExit
          exited = true
        end

        expect(exited).to be(false)
      end
    end

    context 'when incorrect' do
      before :all do
        ::FileUtils.cp(::File.join(uncompiled_path, 'extend.rabl'), ::File.join(compiled_path, 'extend.rabl'))
        ::FileUtils.cp(::File.join(uncompiled_path, 'app_already_compiled.rabl'),
                       ::File.join(compiled_path, 'app_already_compiled.rabl'))
      end

      after :all do
        FileUtils.remove_file(::File.join(compiled_path, 'extend.rabl'), true)
        FileUtils.remove_file(::File.join(compiled_path, 'app_already_compiled.rabl'), true)
      end

      it 'verifies the files in the path and raises error' do
        task = ::Rake::Task['rabl:extend:compiler:verify']

        begin
          task.invoke
        rescue SystemExit => e
          expect(e.status).to eq(1)
        end
      end
    end
  end
end
