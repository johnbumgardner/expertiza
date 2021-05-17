describe Ta do
  let!(:ta) { create(:teaching_assistant, id: 999) }
  let(:course1) { build(:course, id: 1, name: 'ECE517') }
  let(:course2) { build(:course, id: 2, name: 'ECE506') }
  let(:instructor) { build(:instructor, id: 6) }
  let(:assignment) { build(:assignment, id: 1, name: 'no assignment', participants: [participant], teams: [team]) }
  let(:participant) { build(:participant, id: 1) }
  let(:team) { build(:assignment_team, id: 1, name: 'no team') }
  describe '#teaching_assistant?' do
    it 'returns true for a teaching assistant' do
      expect(ta.teaching_assistant?).to be_truthy
    end
  end
  describe '#assign_courses_to_assignment' do
    it 'returns associated courses' do
      allow(TaMapping).to receive(:get_courses).with(999).and_return([course1, course2])
      expect(ta.assign_courses_to_assignment).to eq([course1, course2])
    end
  end
  describe '#courses_assisted_with' do
    it 'returns a map of courses' do
    	ta_mapping = TaMapping.new
    	allow(ta_mapping).to receive(:course_id).and_return(1)
      allow(TaMapping).to receive(:where).with(ta_id: 999).and_return([ta_mapping])
      allow(Course).to receive(:find).with(1).and_return(course1)
      expect(ta.courses_assisted_with).to eq([course1])
    end
  end
  describe '#list_all' do
    it 'returns all objects of a given type associated with a user' do
      allow(Assignment).to receive(:where).with(["instructor_id = ? OR private = 0", 6]).and_return([assignment])
      expect(ta.list_all(Assignment, 6)).to eq([assignment])
    end
  end
  describe '#list_mine' do
    context 'when the object is an assignment' do
      it 'finds associated assignments with TA' do
        allow(Assignment).to receive(:find_by_sql).with(["select assignments.id, assignments.name, assignments.directory_path " \
      "from assignments, ta_mappings where assignments.course_id = ta_mappings.course_id and ta_mappings.ta_id=?", 6]).and_return([assignment])
        expect(ta.list_mine(Assignment, 6)).to eq([assignment])
      end
    end
    context 'when the object is not an assignment' do
      it 'finds associated courses with TA' do
        allow(Course).to receive(:where).with(["instructor_id = ?", 6]).and_return([course1, course2])
        expect(ta.list_mine(Course, 6)).to eq([course1, course2])
      end
    end
  end
  describe '#get' do
    it 'returns all objects of a given type associated with a user' do
      allow(Assignment).to receive(:where).with(["id = ? AND (instructor_id = ? OR private = 0)", 999, 6]).and_return([assignment])
      expect(ta.get(Assignment, 999, 6)).to eq(assignment)
    end
  end
  describe '#get_my_instructors' do
    context 'there are no TaMappings for the user' do
      it 'returns an empty array' do
        allow(TaMapping).to receive(:where).with(ta_id: 999).and_return([])
        expect(Ta.get_my_instructors(ta.id)).to be_empty
      end
    end
    context 'there are  TaMappings for the user' do
      it 'returns an empty array' do
        allow(TaMapping).to receive(:where).with(ta_id: 999).and_return(ta_mapping)
        allow(ta_mapping).to receive(:course_id).and_return(1)
        allow(Course).to receive(:find).with(1).and_return(course1)
        allow(course1).to receive(:instructor_id).and_return(6)
        expect(Ta.get_my_instructors(ta.id)).to eq([6])
      end
    end
  end
end