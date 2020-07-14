class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true
  # Данная модель создает для себя переменную, делая запрос на сайт.
      # и методом new создается новый экземпляр класса, в который записываются поля в соответсвии с Переменной Client


  def self.new_lookup(ticker_symbol)

    client = IEX::Api::Client.new(
        publishable_token: 'Tpk_ee1d714f88de4145a248e4dc29150ed9',
        secret_token: 'Tsk_36dc4c7f7e59476b8bc89e8b8787dc46',
        endpoint: 'https://sandbox.iexapis.com/v1')

    # Метод для выхода, если введены некоректные данные
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
    rescue => exception
      # если пришла ошибка в данных, то возвращаем nil, который затем анализируем в контроллере
      return nil
    end
  end


  # Вспоиогательный метод для контроллера UserStocks, который проверяет наличии Stock в БД
  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

end
