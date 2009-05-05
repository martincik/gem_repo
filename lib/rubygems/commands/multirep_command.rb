require 'yaml'

require 'rubygems/command'
require 'rubygems/multirep'

#new, #execute, #arguments, #defaults_str, #description and #usage
#Gem.ensure_gem_subdirectories @gem_home
class Gem::Commands::MultirepCommand < Gem::Command

  system_config_path = 
    begin
      require 'Win32API'

      CSIDL_COMMON_APPDATA = 0x0023
      path = 0.chr * 260
      SHGetFolderPath = Win32API.new 'shell32', 'SHGetFolderPath', 'LLLLP', 'L'
      SHGetFolderPath.call 0, CSIDL_COMMON_APPDATA, 0, 1, path

      path.strip
    rescue LoadError
      '/etc'
    end
    
  DEFAULT_CONFIG_FILE = File.join system_config_path, 'repositories_gemrc'
  
  def initialize
    @repositories = []
    
    super 'multirep', "Add capability to have multiple local GEM repositories"

    add_option('-a', '--add PATH', 'Add new repository to list') do |value, options|
      options[:add] = value
    end

    add_option('-r', '--remove PATH', 'Remove repository from list') do |value, options|
      options[:remove] = value
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
    @repositories = load_file(DEFAULT_CONFIG_FILE)
    
    if options[:add] || options[:remove]
      if options[:add]
        require 'ruby-debug'
        debugger
        
        @repositories << options[:add]
      elsif options[:remove]
        @repositories.delete(options[:remove])
      end
      
      save_file(DEFAULT_CONFIG_FILE)
    end
    
    say "List of repositories:"
    say @repositories
  end
  
  private 
  
    def load_file(filename)
      begin
        YAML.load(File.read(filename)) if filename and File.exist?(filename)
      rescue ArgumentError
        warn "Failed to load #{filename}"
      rescue Errno::EACCES
        warn "Failed to load #{filename} due to permissions problem."
      end or []
    end
    
    def save_file(filename)
      begin
        return unless filename
        
        File.open( filename, 'w' ) do |out|
          YAML.dump( @repositories, out )
        end
      rescue ArgumentError
        warn "Failed to write #{filename}"
      rescue Errno::EACCES
        warn "Failed to write #{filename} due to permissions problem."
      end
    end
  
end