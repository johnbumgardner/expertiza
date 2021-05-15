class MultipleChoiceCheckbox < QuizQuestion
  def edit
    quiz_question_choices = QuizQuestionChoice.where(question_id: self.id)

    html = '<tr><td>'
    html += '<textarea cols="100" name="question[' + self.id.to_s + '][txt]" '
    html += 'id="question_' + self.id.to_s + '_txt">' + self.txt + '</textarea>'
    html += '</td></tr>'

    html += '<tr><td>'
    html += 'Question Weight: '
    html += '<input type="number" name="question_weights[' + self.id.to_s + '][txt]" '
    html += 'id="question_wt_' + self.id.to_s + '_txt" '
    html += 'value="' + self.weight.to_s + '" min="0" />'
    html += '</td></tr>'

    # for i in 0..3
    [0, 1, 2, 3].each do |i|
      html += "<tr><td>"

      html += '<input type="hidden" name="quiz_question_choices[' + self.id.to_s + '][MultipleChoiceCheckbox][' + (i + 1).to_s + '][iscorrect]" '
      html += 'id="quiz_question_choices_' + self.id.to_s + '_MultipleChoiceCheckbox_' + (i + 1).to_s + '_iscorrect" value="0" />'

      html += '<input type="checkbox" name="quiz_question_choices[' + self.id.to_s + '][MultipleChoiceCheckbox][' + (i + 1).to_s + '][iscorrect]" '
      html += 'id="quiz_question_choices_' + self.id.to_s + '_MultipleChoiceCheckbox_' + (i + 1).to_s + '_iscorrect" value="1" '
      html += 'checked="checked" ' if quiz_question_choices[i].iscorrect
      html += '/>'

      html += '<input type="text" name="quiz_question_choices[' + self.id.to_s + '][MultipleChoiceCheckbox][' + (i + 1).to_s + '][txt]" '
      html += 'id="quiz_question_choices_' + self.id.to_s + '_MultipleChoiceCheckbox_' + (i + 1).to_s + '_txt" '
      html += 'value="' + quiz_question_choices[i].txt + '" size="40" />'

      html += '</td></tr>'
    end

    html.html_safe
    # safe_join(html)
  end

  def complete
    quiz_question_choices = QuizQuestionChoice.where(question_id: self.id)
    html = "<label for=\"" + self.id.to_s + "\">" + self.txt + "</label><br>"
    # for i in 0..3
    [0, 1, 2, 3].each do |i|
      # txt = quiz_question_choices[i].txt
      html += "<input name = " + "\"#{self.id}[]\" "
      html += "id = " + "\"#{self.id}" + "_" + "#{i + 1}\" "
      html += "value = " + "\"#{quiz_question_choices[i].txt}\" "
      html += "type=\"checkbox\"/>"
      html += quiz_question_choices[i].txt.to_s
      html += "</br>"
    end
    html
  end

  def view_completed_question(user_answer)
    quiz_question_choices = QuizQuestionChoice.where(question_id: self.id)
    html = ''
    quiz_question_choices.each do |answer|
      html += '<b>' + answer.txt + '</b> -- Correct <br>' if answer.iscorrect
    end
    html += '<br>Your answer is:'
    html += if user_answer[0].answer == 1
              '<img src="/assets/Check-icon.png"/><br>'
            else
              '<img src="/assets/delete_icon.png"/><br>'
            end
    user_answer.each do |answer|
      html += '<b>' + answer.comments.to_s + '</b><br>'
    end
    html += '<br><hr>'
    html.html_safe
    # safe_join(html)
  end

  def valid?(choice_info)
    return "Please make sure all questions have text" if self.txt.nil? || self.txt.empty?
    correct_count = 0
    choice_info.each_value do |value|
      return "Please make sure every question has text for all options" if value.txt.nil? || value.txt.empty? 
      correct_count += 1 if value.iscorrect == 1.to_s
    end
    if correct_count.zero?
      return "Please select a correct answer for all questions"
    elsif correct_count == 1
      return "A multiple-choice checkbox question should have more than one correct answer."
    end
    "valid"
  end
end
