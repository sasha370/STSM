class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

  def my_portfolio
    @tracked_stocks = current_user.stocks
    @user = current_user
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
      if @friends.empty?
        respond_to do |format|
          flash.now[:alert] = "Никого не найдено по этим данным"
          format.js { render partial: 'friends/result' }
        end
      else
        respond_to do |format|
          format.js { render partial: 'friends/result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Пожалуйста введите Имя или Email друга"
        format.js { render partial: 'friends/result' }
      end
    end
  end
end
