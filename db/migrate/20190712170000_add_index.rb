class AddIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :attendances, :work_on
  end
end
