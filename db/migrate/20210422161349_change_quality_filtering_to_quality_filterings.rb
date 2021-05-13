class ChangeQualityFilteringToQualityFilterings < ActiveRecord::Migration
  def change
    rename_table :quality_filtering, :quality_filterings
  end
end
