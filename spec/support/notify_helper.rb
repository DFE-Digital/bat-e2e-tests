require "notifications/client"
require "uri"

module NotifyHelper
  class EmailNotFound < StandardError; end
  class LinkNotFound < StandardError; end

  def sign_in_link(email)
    link = extract_link(email)
    if link&.start_with? "#{ENV["APPLY_URL"]}/candidate/sign-in/confirm?token="
      link
    else
      raise LinkNotFound, "No sign in link found in email: #{email.body}"
    end
  end

  def wait_for_email(to:, wait: 15)
    wait_until = Time.now + wait

    # Find email sent within the last 5 seconds (in case it's already been sent)
    # but no earlier, to avoid detecting old emails from a previous test run.
    sent_after = Time.now - 5

    while Time.now < wait_until
      emails = notify_client.get_notifications(template_type: "email").collection

      matching_email = emails.detect do |email|
        email.email_address == to && email.created_at > sent_after
      end

      if matching_email
        return matching_email
      else
        sleep 1
      end
    end

    raise EmailNotFound, "An email was not sent to #{to} within #{wait} seconds"
  end

  private

  def extract_link(email)
    URI.extract(email.body, :https).first
  end

  def notify_client
    Notifications::Client.new(ENV["NOTIFY_API_KEY"])
  end
end
