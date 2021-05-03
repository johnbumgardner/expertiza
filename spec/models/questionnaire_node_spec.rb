describe QuestionnaireNode do
	let(:questionnaire) do
    build(id: 1, name: 'questionnaire', ta_id: 8, course_id: 1, private: false, min_question_score: 0, max_question_score: 5, type: 'ReviewQuestionnaire')
  end
  let(:questionnaire_node) {build (:questionnaire_node)}
  it { should belong_to(:questionnaire) }
  it { should belong_to(:node_object) }
  describe '#table' do
    it 'returns the name of the table'
      expect(QuestionnaireNode.table).to eq('questionnaires')
    end
  end
  describe '#is_leaf' do
    it 'returns whether the node is a leaf'
      expect(questionnaire_node).to eq(true)
    end
  end
end