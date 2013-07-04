
module RockBuild
  class Profile
    attr_reader :packages

    def initialize
      @packages = packages
    end

    def self.load(profile_name)
      name = profile_name.split('-').map{|e| e.capitalize }.join('')
      Object.const_get(name).new
    end

    def setup
      puts "setup"
    end


    def build
      if clean_build_root?:
        log 0, "Rebuilding world - new prefix: #{@release_root}"
        RockBuild::ShUtils::rmtree(@build_root)
      end

      puts "build"
    end

    def install
      puts "install"
    end

    def package
      puts "package"
    end

    def run(env)
      @env = env
      setup
      build
      install
      package if env.package?
    end

    def log(level,msg)
      puts msg
    end
  end
end