require_relative "discord_mailer/version"
require_relative 'discord_mailer/configuration'
require 'erb'

module Discord
  class Error < StandardError
    EMPTY_WEBHOOK_ID = 'Webheook id is empty!'
    EMPTY_WEBHOOK_KEY = 'Webhook key is empty!'
    EMPTY_MESSSAGE = 'Message text is empty!'

  end
  class Mailer
    class << self
      def method_missing(method, *args)
        self.new.send(method, *args)
      end

      def send_message(webhook_id = '', webhook_key = '', name = '', message = '')
        raise Error::EMPTY_MESSSAGE if message.empty?
        discord_url = "#{Discord::Mailer::Configuration.config.discord_url}/#{webhook_id}/#{webhook_key}"

        RestClient.post(discord_url, {"username" => name,"content" => message})
      end
    end

    def mail(webhook_id: nil, webhook_key: nil, from: nil)
      raise Error::EMPTY_WEBHOOK_ID if webhook_id.empty?
      raise Error::EMPTY_WEBHOOK_KEY if webhook_key.empty?

      template_name = caller_locations.first.base_label
      message = collect_message(self.template_path(template_name), _instance_variables)
      self.class.send(:send_message, webhook_id, webhook_key, from, message)
    end

    def _instance_variables
      instance_variables.map { |instance_variable|
        { instance_variable => self.instance_variable_get(instance_variable) }
      }.reduce(:merge)
    end

    def template_path(template_name)
      template = "#{template_name}.#{Discord::Mailer::Configuration.config.templates_type}"
      template << '.erb' if Discord::Mailer::Configuration.config.erb_in_templates

      "#{Discord::Mailer::Configuration.config.templates_path}/#{self.class.name.underscore}/#{template}"
    end

    def collect_message(template_path, instance_variables)
      ERB.new(File.read(template_path)).result(binding)
    end
  end
end
