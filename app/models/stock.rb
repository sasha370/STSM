class Stock < ApplicationRecord

  def self.new_lookup(ticker_symbol)

    client = IEX::Api::Client.new(
        publishable_token: 'Tpk_ee1d714f88de4145a248e4dc29150ed9',
        secret_token: 'Tsk_36dc4c7f7e59476b8bc89e8b8787dc46',
        endpoint: 'https://sandbox.iexapis.com/v1')
    new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))

  end


end
