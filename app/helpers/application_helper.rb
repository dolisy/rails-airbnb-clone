module ApplicationHelper
  def format_provider(provider)
    return provider unless provider == "GoogleOauth2"
    "Google"
  end
end
