module ApplicationHelper
  def format_provider(provider)
    return provider unless provider == "GoogleOauth2"
    "Google"
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
