class StocksController < ApplicationController

  def search

    # Первая проверка: передал ли ПОИСК в params хоть чтото?
    if params[:stock].present?
      # Если есть такой атрибут, то создаем с помощью модели Переменную или получаем NIL, если с сайта пришла ошибка
      @stock = Stock.new_lookup(params[:stock])
      # Проверяем создалась ли переменная, если Даб то отрисовываем результат
      if @stock
        # Если переменная создалась, то отправляем данные в форму для JS
        respond_to do |format|
          format.js {render partial: 'users/result'}
        end

      else
        # если нет, то перенаправляем на новый ввод и сообщаем о ошибке
        flash[:alert] = "Пожалуйста введите ПРАВИЛЬНОЕ название Акции"
        redirect_to my_portfolio_path
      end
      # Если в params отсутвует поле stock, то значит был поиск по пустой строке
    else
      flash[:alert] = "Пожалуйста введите название Акции"
      redirect_to my_portfolio_path
    end
  end

end