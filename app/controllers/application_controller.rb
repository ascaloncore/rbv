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

  # 他のユーザーのリソースにアクセスしようとした場合の処理
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  private

  def require_login
    return if logged_in?

    redirect_to login_path
  end

  def handle_record_not_found
    redirect_to login_path, danger: I18n.t("controllers.application.record_not_found")
  end
end
