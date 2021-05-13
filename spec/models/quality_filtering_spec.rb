describe QualityFiltering do
	let(:assignment) { build(:assignment, id: 1, name: 'Test Assgt') }
  let(:team) { build(:assignment_team) }
	let(:review_response_map) { build(:review_response_map, assignment: assignment, reviewer: participant, reviewee: team) }
	let(:response) { build(:response, id: 1, map_id: 1, response_map: review_response_map, scores: [answer]) }
  let(:ct_criterion) { Criterion.new id: 1, type: "Criterion", seq: 1.0, txt: "test txt", weight: 1 }
  let(:answer_short) { Answer.new question: ct_criterion, answer: 5, comments: "yes" }
  let(:answer_long) { Answer.new question: ct_criterion, answer: 5, comments: "very good project. this should not be filtered out because this is long!!!" }
  let(:answer_normal1) { Answer.new question: ct_criterion, answer: 5, comments: "yes" }
  let(:answer_normal2) { Answer.new question: ct_criterion, answer: 5, comments: "yes" }
  let(:answer_outlier) { Answer.new question: ct_criterion, answer: 5, comments: "no" }

  it { should belong_to :tag_prompt_deployment }
  describe '#apply_threshold_filter' do
    it 'filters out comments below a certain length threshold' do
      thrsh = 5
      answers = [answer_long, answer_short]
      expect(QualityFiltering.apply_threshold_filter(answers, thrsh)).to eq([answer_long])
    end
  end
  describe '#apply_outlier_filter' do
    context 'when no answers are provided' do
      it 'returns nil or an empty array' do
        answers = []
        expect(QualityFiltering.apply_outlier_filter(answers)).to eq(answers)
      end
    end
    context '' do
      it '' do

      end
    end
  end

end