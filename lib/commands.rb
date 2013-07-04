require 'profile'
require 'buildenv'

module RockBuild
  module Commands
    class Command
    end

    class Build < Command
      def self.process(args, options)
        env = RockBuild::BuildEnv.new(args, options)
        profile = env.load_profile
        profile.run env
      end
    end
  end
end