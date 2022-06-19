# DiscordMailer
DiscordMailer gem helps separate business logic from logic of message delivery. It structures code just like ActionMailer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'discord_mailer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install discord_mailer

## Configuring

Create configuration file config/initializers/discord_mailer.rb

```ruby
Discord::Mailer::Configuration.configure do |config|
  config.templates_path = "#{Rails.root}/app/views/discord_templates/"
  config.templates_type = 'text'
  config.erb_in_templates = true
  config.discord_url = 'https://discord.com/api/webhooks'
end
```
Gem balances messages by hooks. It helps not to reach a message limit through 1 hook per 1 second.

## Usage

app/discord_mailers/user_mailer.rb

```ruby
class UserMailer < Discord::Mailer

  def created(user)
    @user = user
    mail(webhook_id: 'webhook_id', webhook_key: 'webhook_key', from: 'from')
  end

end
```

Mailer will be using template *app/views/discord_templates/user_mailer/created.text.erb*

```text
Name: <%= @user.name %>
Full name: <%= @user.full_name %>
Phone: <%= @user.phone %>
```
#### Sending messages
```ruby
UserMailer.created(user)
```

Sending small messages(one line message)
```ruby
Discord::Mailer.send_message('webhook_id, 'webhook_key', 'name', 'message)
```
