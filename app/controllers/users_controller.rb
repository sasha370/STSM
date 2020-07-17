class UsersController < ApplicationController


  def my_portfolio
    # Выбирем все акции, которые привызанны к текущему пользователю. Current_user обеспечен Devise
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search

    # Первая проверка: передал ли ПОИСК в params хоть чтото?
    if params[:friend].present?
      # Если есть такой атрибут, то создаем с помощью модели Переменную или получаем NIL, если с сайта пришла ошибка
      @friend = params[:friend]
      # Проверяем создалась ли переменная, если Даб то отрисовываем результат
      if @friend
        # Если переменная создалась, то отправляем данные в форму для JS
        respond_to do |format|
          format.js { render partial: 'friends/result' }
        end

      else
        # если нет, то перенаправляем на новый ввод и сообщаем о ошибке
        # flash[:alert] = "Пожалуйста введите ПРАВИЛЬНОЕ название Акции"
        # redirect_to my_portfolio_path

        # Заменео на JS
        respond_to do |format|
          flash.now[:alert] = "Никого не найдено по этим данным"
          format.js { render partial: 'friends/result' }
        end
      end
      # Если в params отсутвует поле stock, то значит был поиск по пустой строке
    else
      # flash[:alert] = "Пожалуйста введите название Акции"
      # redirect_to my_portfolio_path

      # Заменео на JS
      respond_to do |format|
        flash.now[:alert] = "Пожалуйста введите Имя или Email друга"
        format.js { render partial: 'friends/result' }
      end
    end
  end


end
