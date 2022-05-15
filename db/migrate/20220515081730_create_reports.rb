class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.string :main_file_name
      t.integer :status
      t.string :report_dir_name
      t.references :assignment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
