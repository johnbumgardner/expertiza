describe QualityFiltering do
  let(:ct_criterion) { Criterion.new id: 1, type: "Criterion", seq: 1.0, txt: "test txt", weight: 1 }
  let(:answer_short) { Answer.new question: ct_criterion, answer: 5, comments: "yes" }
  let(:answer_long) { Answer.new question: ct_criterion, answer: 5, comments: "very good project. this should not be filtered out because this is long!!!" }
  it { should belong_to :tag_prompt_deployment }
  describe '#apply_threshold_filter' do
    it 'filters out comments below a certain length threshold' do
      thrsh = 5
      answers = [answer_long, answer_short]
      expect(QualityFiltering.apply_threshold_filter(answers, thrsh)).to eq([answer_long])
    end
  end
end