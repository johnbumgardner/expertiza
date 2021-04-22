class AddTagPromptDeploymentRefToQualityFiltering < ActiveRecord::Migration
  def change
    add_reference :quality_filterings, :tag_prompt_deployment, foreign_key: true
  end
end
