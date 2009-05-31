# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gem_repo}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ladislav Martincik"]
  s.date = %q{2009-05-31}
  s.description = %q{A gem command plugin which helps you have multiple local repositories of GEMs on your computer.}
  s.email = %q{ladislav.martincik@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/rubygems/commands/repo_command.rb",
    "lib/rubygems/repo.rb",
    "lib/rubygems_plugin.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/lacomartincik/gem_repo}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{A gem command plugin which helps you have multiple local repositories of GEMs on your computer.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
