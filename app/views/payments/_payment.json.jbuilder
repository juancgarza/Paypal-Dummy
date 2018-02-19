json.extract! payment, :id, :code, :payment_method, :amount, :currency, :created_at, :updated_at
json.url payment_url(payment, format: :json)
