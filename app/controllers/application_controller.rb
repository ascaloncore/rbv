# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Sorcery helper methods
  include Sorcery::Controller

  # Make current_user available in views
  helper_method :current_user

  # Custom flash types
  add_flash_types :success, :info, :warning, :danger
end
