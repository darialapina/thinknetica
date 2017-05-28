class AddIsBestToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :is_best, :boolean, default: false
  end
end
