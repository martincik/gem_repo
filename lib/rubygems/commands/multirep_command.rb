require 'yaml'

require 'rubygems/command'
require 'rubygems/multirep'

#new, #execute, #arguments, #defaults_str, #description and #usage
# Change Gem.gem_home
# Gem.ensure_gem_subdirectories @gem_home
# Gem.pre_install

class Gem::Commands::MultirepCommand < Gem::Command

  def initialize
    @repositories = []
    
    super 'rep', "Add capability to have multiple local GEM repositories"

    add_option('-a', '--add ALIAS:GEM_HOME', 'Add new GEM_HOME to list of repositories with ALIAS name') do |value, options|
      options[:add] = value.split(':')
    end

    add_option('-r', '--remove ALIAS', 'Remove repository with ALIAS from list') do |value, options|
      options[:remove] = value
    end
    
    add_option('-t', '--activate ALIAS', 'Activate ALIAS') do |value, options|
      options[:activate] = value
    end
    
    add_option('-d', '--deactivate', 'Deactivate active GEM_HOME to old value') do |value, options|
      options[:deactivate] = true
    end
    
    remove_option '--config-file'
  end

  def usage # :nodoc:
    "#{program_name}"
  end
  
  def description # :nodoc:
    ""
  end
  
  def execute
    @repo = Gem::Repo.new
    
    if options[:add] || options[:remove]
      if options[:add]
        @repo.add_repository(options[:add])
        say "Repository #{options[:add][1]} aliased as #{options[:add][0]} added successfully."
      elsif options[:remove]
        @repo.remove_repository(options[:remove])
        say "Repository aliased as #{options[:remove]} removed successfully."
      elsif options[:activate]
        begin
          @repo.activate(options[:activate])          
        rescue AliasNotFound => e
          say "Alias #{options[:activate]} not found!"
        end
      elsif options[:deactivate]
        @repo.deactivate
      end
      
      return
    end
    
    say "List of repositories:"
    say @repo
  end
  
end