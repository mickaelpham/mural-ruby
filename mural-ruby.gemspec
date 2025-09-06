# frozen_string_literal: true

require_relative 'lib/mural/version'

Gem::Specification.new do |spec|
  spec.name = 'mural-ruby'
  spec.version = Mural::VERSION
  spec.authors = ['Mickaël Pham']
  spec.email = ['inbox@mickael.dev']

  spec.summary = 'Ruby library for the Mural public API'
  spec.homepage = 'https://github.com/mickaelpham/mural-ruby'
  spec.required_ruby_version = '>= 3.2.0'
  spec.license = 'Unlicense'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .rubocop.yml])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'zeitwerk', '~> 2.7'
end
