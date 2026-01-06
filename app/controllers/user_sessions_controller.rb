# frozen_string_literal: true

class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to root_path, success: "ログインしました。", status: :see_other
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが間違っています。"
      @user = User.new
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "ログアウトしました。", status: :see_other
  end
end
