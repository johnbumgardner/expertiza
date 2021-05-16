class AssignmentQuestionnaire < ApplicationRecord
  belongs_to :assignment
  belongs_to :questionnaire
  belongs_to :sign_up_topic
  has_paper_trail

  scope :retrieve_questionnaire_for_assignment, lambda {|assignment_id|
    joins(:questionnaire).where('assignment_questionnaires.assignment_id = ?', assignment_id)
  }
end
