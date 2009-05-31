require 'yaml'

require 'rubygems/command'
require 'rubygems/repo'

class Gem::Commands::RepoCommand < Gem::Command

  def initialize
    @repositories = []
    
    super 'repo', "Add capability to have multiple local GEM repositories"
    
    add_option('-a', '--add ALIAS:GEM_HOME', 'Add new GEM_HOME to list of repositories with ALIAS name') do |value, options|
      options[:add] = value.split(':')
    end

    add_option('-r', '--remove ALIAS', 'Remove repository with ALIAS from list') do |value, options|
      options[:remove] = value
    end
    
    add_option('-t', '--activate ALIAS', 'Activate ALIAS') do |value, options|
      options[:activate] = value
    end
    
    add_option('-d', '--deactivate', 'Deactivate to original GEM_HOME') do |value, options|
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
    
    if options[:add] || options[:remove] || options[:activate] || options[:deactivate]
      if options[:add]
        @repo.add_repository(options[:add][0], options[:add][1])
        say "Repository '#{options[:add][1]}' aliased as '#{options[:add][0]}' added successfully."
      elsif options[:remove]
        @repo.remove_repository(options[:remove])
        say "Repository aliased as '#{options[:remove]}' removed successfully."
      elsif options[:activate]
        begin
          @repo.activate(options[:activate])          
          say "Alias #{options[:activate]} successfully activated!"
        rescue AliasNotFound => e
          say "Alias #{options[:activate]} not found!"
        end
      elsif options[:deactivate]
        @repo.deactivate
        say "Successfully deactivated!"
      end
      
      return
    end
    
    say "List of repositories:"
    say @repo
  end
  
end