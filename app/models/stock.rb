class Stock < ApplicationRecord

  def self.new_lookup(ticker_symbol)

    client = IEX::Api::Client.new(
        publishable_token: 'pk_452b528c3d524ff19a7631634ec4f5f8',
        endpoint: 'https://cloud.iexapis.com/v1')
    client.price(ticker_symbol)
  end


end
