class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.datetime :start, null: false
      t.datetime :end, null: false
      t.string :color, limit: 7
      t.boolean :all_day, null: false, default: false

      t.timestamps
    end
  end
end
