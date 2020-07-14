class UserStocksController < ApplicationController
  def create
    # Проверяем есть ли Текущая Акция в БД. в Params поле ticker передается из строки поиска
    stock = Stock.check_db(params[:ticker])

    # Если таких акций в БД нет, то
    if stock.blank?
      # ищем ее на сайте и парсим в переменную
      stock = Stock.new_lookup(params[:ticker])
      # сохраняем в БД
      stock.save
    end
    # Создаем взаимосвязь Акция-юзер, где в качестве user_id достаем из Current_user(bp devise), а ID акции и созданной переменной
    @user_stock = UserStock.create(user: current_user, stock: stock)
    # Показываем сообщение о добавлении и перенаправляем в ЛК
    flash[:notice] = " Акции #{stock.name} успешно добавлены в портфель"
    redirect_to my_portfolio_path
  end
end
