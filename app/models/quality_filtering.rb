class QualityFiltering < ActiveRecord::Base
	belongs_to :tag_prompt_deployment
	FILTERING_METHODS = [:threshold_filter, :outlier_filter].freeze
	def self.apply_filters(answers, filters)
		# Filters is a list of filters to apply, so [:threshold_filter, :outlier_filter]
		filters.each do |filter|
			# call appropriate filtering method if the filter in the static maintainable list
			answers = self.multiplex_to_filter(answers, filter) if FILTERING_METHODS.include? filter
		end 
		answers
	end

	# Based on desired filters, call the specific filter function
	def self.multiplex_to_filter(answers, filter)
		case filter
		when :threshold_filter
			threshold = tag_prompt_deployment.answer_length_threshold
			answers = self.apply_threshold_filter(answers, threshold)
		when :outlier_filter
      threshold = 5
			answers = self.apply_outlier_filter(answers, threshold)
		end
		answers
	end

	# Filter out all answers with comment length less than a set threshold
	def self.apply_threshold_filter(answers, threshold)
		answers = answers.select{|answer| answer.comments.split(' ').length > threshold}
	end

  # Filter out all answers which is the outlier in their group
	def self.apply_outlier_filter(answers) 
    unless answers.empty?
      answers.each do |answer|
        question = answer.question
        response = answer.response
        response_map = response.response_map
        reviewer = response_map.reviewer
        team = reviewer.team
        teammates = team.participants
        teammates.delete(reviewer) if teammates.include? reviewer && team.participants.count >= 3
        tags_for_same_answer = []
        teammates.each do |teammate| 
          # compare reviewer with his teammates
          user = teammate.user
          # belong to one teammate 
          tags_for_same_answer << AnswerTag.where(tag_prompt_deployment_id: tag_prompt_deployment.id, user_id: user.id, answer_id: answer.id).first
        end
        # tag_for_same_answer
        # detect outliers based on each elements value
        tag_in_question = AnswerTag.where(tag_prompt_deployment_id: tag_prompt_deployment.id, user_id: reviewer.user.id, answer_id: answer.id).first
        if tags_for_same_answer.uniq.size <= 1 and tags_for_same_answer.first != tag_in_question
          answer.remove(answer)
        end
      end
    end
    answers
  end
end