class CreateAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :assignments do |t|
      t.string :name
      t.string :description
      t.string :template_file_name

      t.timestamps
    end
  end
end
