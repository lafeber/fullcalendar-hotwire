class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.string :color, limit: 7
      t.boolean :all_day, null: false, default: false
      t.json :recurring
      t.integer :parent_id

      t.timestamps
    end
  end
end
