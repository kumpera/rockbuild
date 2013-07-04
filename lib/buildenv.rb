require 'package'
require 'profile'

module RockBuild
  class BuildEnv

    def initialize(args,options)
      @args = args
      @options = options

      raise Exception.new "Too many arguments" if args.size > 1

      @builtin_path = File.join(ROCKBUILD_PATH, *%w{ .. repo })
      @vendor_path = File.join(ROCKBUILD_PATH, *%w{ .. vendor })
      @search_path = [ @builtin_path, @vendor_path ]

      @search_path  \
        .product([".", "packages", "profiles"]) \
        .map {|p| File.join(p[0], p[1]) } \
        .select {|p| File.exists? p } \
        .collect{|p| Dir.glob(File.join(p, "*.rb")) } \
        .flatten  \
        .each { |p| Kernel.load p }
        
      $LOAD_PATH << p

      if args.size == 0:
        @profile_name = File.split(Dir.pwd).last
      else
        @profile_name = args.first  
      end
    end

    def load_profile
      Profile.load @profile_name
    end

    def package?
      @options.package
    end

  end
end
    