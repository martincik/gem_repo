class AliasNotFound < Exception; end

module Gem
  class Repo
  
    DEFAULT_CONFIG_FILE = File.join Gem.user_home, '.gemreporc'
    
    def initialize
      @config = load_file
    end
    
    def add_repository(_alias, gem_home)
      config[_alias] = gem_home
      save_file
    end
    
    def remove_repository(_alias)
      config.delete(_alias)
      save_file
    end
    
    def activate(_alias)
      raise AliasNotFound.new(_alias) unless config.include?(_alias)
      
      configuration = Gem.configuration
      @config[:original_gemhome] = configuration.home
      @config[:original_gempath] = configuration.path
      configuration[:gemhome] = config[_alias]
      configuration[:gempath] = [config[_alias]]
      configuration.write
      save_file
    end
    
    def deactivate
      configuration = Gem.configuration
      configuration[:gemhome] = @config[:original_gemhome]
      configuration[:gempath] = @config[:original_gempath]
      configuration.write
    end
    
    def to_s
      s = ''
      config.each do |key, value|
        s += "\t#{key} => #{value}\n"
      end
      s
    end

    private
    
      def config
       @config[:repo] ||= Hash.new
      end

      def load_file(filename = DEFAULT_CONFIG_FILE)
       begin
         YAML.load(File.read(filename)) if filename and File.exist?(filename)
       rescue ArgumentError
         warn "Failed to load #{filename}"
       rescue Errno::EACCES
         warn "Failed to load #{filename} due to permissions problem."
       end or {}
      end

      def save_file(filename = DEFAULT_CONFIG_FILE)
       begin
         return unless filename

         File.open( filename, 'w' ) do |out|
           YAML.dump( @config, out )
         end
       rescue ArgumentError
         warn "Failed to write #{filename}"
       rescue Errno::EACCES
         warn "Failed to write #{filename} due to permissions problem."
       end
      end
      
  end
end
