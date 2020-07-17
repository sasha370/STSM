class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

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
    return "#{first_name} #{last_name}" if first_name || last_name
    "Гость"
  end

  # SEARCH - объединяющий метод для поиска
  # Подготовка строки для поиска
  # Сначала обрезаем все пробельные символы
  def self.search(param)
    param.strip!
    # затем в переменную записываем результаты поисковых запросов , но выбираем только Uniq? чтобы не дублировались
    to_send_back = (first_name_matches(param) + last_name_matches(param) + email_name_matches(param)).uniq
    # Вернуть нил, если нет результатов
    return nil unless to_send_back
    # Или вернуть результат
    to_send_back
  end

  # Поиск по полю Имя
  def self.first_name_matches(param)
    matches('first_name', param)
  end

  # оиск по полю Фамилия
  def self.last_name_matches(param)
    matches('last_name', param)
  end
  # Поиск по email
  def self.email_name_matches(param)
    matches('email', param)
  end


  # Метод для созданияи запроса в БД
  # В качестве field_name будет передаваться Email или имя, в качесте записи %...%  - шаблон для поиска
  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

  # Метод удаляет из списка текущего пользователя, если его ID равен ID - current_user, у которого вызвали этот метод
  def except_current_user(users)
        users.reject{|user| user.id == self.id}
  end


end
