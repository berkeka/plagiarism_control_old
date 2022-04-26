class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :login
      t.string :name
      t.string :description
      t.string :url
      t.string :html_url
      t.string :avatar_url

      t.timestamps
    end

    add_index :courses, :login, unique: true
  end
end
