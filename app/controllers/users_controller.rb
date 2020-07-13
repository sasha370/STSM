class UsersController < ApplicationController


  def my_portfolio
    # Выбирем все акции, которые привызанны к текущему пользователю. Current_user обеспечен Devise
    @tracked_stocks = current_user.stocks
  end
end
