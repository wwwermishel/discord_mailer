module Discord
  class Mailer
    class Configuration

      attr_accessor :templates_path, :templates_type, :erb_in_templates, :discord_url

      def initialize
        @templates_path = nil
        @templates_type = nil
        @erb_in_templates = false
        @discord_url = nil
      end

      class << self
        def config
          @configuration ||= Discord::Mailer::Configuration.new
        end

        def reset
          @configuration = Discord::Mailer::Configuration.new
        end

        def configure
          yield(config)
        end
      end

    end
  end
end
