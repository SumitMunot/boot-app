class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :page_view
      t.integer :sessions
      t.datetime :date
      t.string :site_id

      t.timestamps
    end
  end
end
