class CreateWirecardTransactions < ActiveRecord::Migration
  def change
    create_table :spree_wirecard_transactions do |t|
      t.integer :order_number

      t.decimal :amount, :precision => 8, :scale => 2
      t.string :currency
      t.string :payment_type

      t.text :params

      t.timestamps
    end
  end
end

