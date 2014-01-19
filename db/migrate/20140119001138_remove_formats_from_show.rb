class RemoveFormatsFromShow < ActiveRecord::Migration
  def change
    remove_column :shows, :format_1, :string
    remove_column :shows, :format_2, :string
    remove_column :shows, :format_3, :string
    remove_column :shows, :format_4, :string
    remove_column :shows, :format_5, :string
  end
end
