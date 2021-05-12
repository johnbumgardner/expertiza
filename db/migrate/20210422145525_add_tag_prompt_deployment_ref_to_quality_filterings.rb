class AddTagPromptDeploymentRefToQualityFilterings < ActiveRecord::Migration
  def change
    add_reference :quality_filtering, :tag_prompt_deployment, foreign_key: true
  end
end