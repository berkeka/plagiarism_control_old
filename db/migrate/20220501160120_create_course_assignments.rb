class CreateCourseAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :course_assignments do |t|
      t.references :course, null: false, foreign_key: true
      t.references :assignment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
