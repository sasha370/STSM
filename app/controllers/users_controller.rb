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
      # Используя метод Search из User.rb создаем список найденых друзей
      @friends = User.search(params[:friend])
      # Данный метод удаляет текущего пользователя из результатов поиска
      @friends = current_user.except_current_user(@friends)
      # Проверяем создалась ли переменная, если Даб то отрисовываем результат
      if @friends.empty?
        respond_to do |format|
          flash.now[:alert] = "Никого не найдено по этим данным"
          format.js { render partial: 'friends/result' }
        end
      else # Если переменная создалась, то отправляем данные в форму для JS
        respond_to do |format|
          format.js { render partial: 'friends/result' }
        end
      end
      # Если в params отсутвует поле friend, то значит был поиск по пустой строке
    else
      respond_to do |format|
        flash.now[:alert] = "Пожалуйста введите Имя или Email друга"
        format.js { render partial: 'friends/result' }
      end
    end
  end


end
