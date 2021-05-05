describe QuizAssignment do
  let(:assignment) { build(:assignment, id: 1, name: 'no assignment', participants: [participant], teams: [team]) }
  let(:instructor) { build(:instructor, id: 6) }
  let(:student) { build(:student, id: 3, name: 'no one') }
  let(:participant) { build(:participant, id: 1) }
  let(:team) { build(:assignment_team, id: 1, parent_id: 1) }
  let(:questionnaire1) { build(:questionnaire, id: 1, type: 'ReviewQuestionnaire') }
  let(:teammate_review_response_map) { build(:review_response_map, type: 'TeammateReviewResponseMap') }
  describe '#candidate_topics_for_quiz' do
    context 'when there are no signup topics' do
      it 'returns nil' do
        expect(assignment.candidate_topics_for_quiz).to eq(nil)
      end
    end
    context 'when there is a sign up topic but no team has signed up for topics' do
      it 'returns an empty set' do
      	assignment.sign_up_topics << build(:topic)
        allow(assignment).to receive(:contributors).and_return([team])
        allow(assignment).to receive(:signed_up_topic).with(team).and_return(nil)  
        expect(assignment.candidate_topics_for_quiz).to eq(Set.new)  
      end
    end
  end
  describe '#quiz_taken_by?' do
  	context 'when the participant has taken one quizzes' do
      it 'returns true' do
        allow(QuizQuestionnaire).to receive(:find_by).with(instructor_id: 6).and_return(questionnaire1)
        allow(QuizResponseMap).to receive(:where).with('reviewee_id = ? AND reviewer_id = ? AND reviewed_object_id = ?', 6, 1, 1).and_return([teammate_review_response_map])
        expect(assignment.quiz_taken_by?(instructor, participant)).to eq(true)
      end
    end 
  end

end