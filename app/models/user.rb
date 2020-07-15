class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Проверяем, не отслеживает ли юзер уже эту акцию
  def stock_already_tracked?(ticker_symbol)
    # В классе stock есть методЮ которые проверяет наличии акции в БД
    # если ее там нет, значит ее вообще никто не может отслеживат
    stock = Stock.check_db(ticker_symbol)
    # значит возвращаем false
    return false unless stock
    # если же в базе уже есть запись, то проверяем нет ли у usera уже ее в портфеле
    # в  записи User.stock опускаем user, т.к. мы уже в этом классе
    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end


  # метод проверяет, может ли юзер добавить еще себе Акций ( по условию не более 9, см выше )
  # используется в _result.htm чтобы не показывать кнопку Добавить.
  def can_track_stock?(ticker_symbol)
    # Метод называется МОЖЕТ ли?  соответсвенно нам нужно использовать отрицание ! в методе stock_already_tracked?( т.е. )
    # Т.е. Записей меньше 9ти ИИ !акция уже отслеживается
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def full_name
    return  "#{first_name} #{last_name}" if first_name || last_name
    "Гость"
  end

end
