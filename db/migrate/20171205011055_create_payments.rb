class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.string :code
      t.string :payment_method
      t.string :amount
      t.string :currency

      t.timestamps
    end
  end
end
