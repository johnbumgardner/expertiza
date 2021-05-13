class QualityFiltering < ActiveRecord::Base
	belongs_to :tag_prompt_deployment
	FILTERING_METHODS = [:threshold_filter, :outlier_filter].freeze
	def apply_filters(answers, filters)
		# Filters is a list of filters to apply, so [:threshold_filter, :outlier_filter]
		filters.each do |filter|
			# call appropriate filtering method if the filter in the static maintainable list
			answers = self.multiplex_to_filter(answers, filter) if FILTERING_METHODS.include? filter
		end 
		answers
	end

	# Based on desired filters, call the specific filter function
	def multiplex_to_filter(answers, filter)
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
	def apply_threshold_filter(answers, threshold)
		answers = answers.select{|answer| answer.comments.split(' ').length > threshold}
	end

  # Filter out all answers which is the outlier in their group
	def apply_outlier_filter(answers, threshold) 
    tag_prompt_deployments = TagPromptDeployment.where(id: self.tag_prompt_deployment_id)
    teams = Team.where(parent_id: tag_prompt_deployments.assignment_id)
    questions = Question.where(questionnaire_id: tag_prompt_deployments.questionnaire.id, type: tag_prompt_deployments.question_type)
    outlier_user_ids = []
    unless teams.empty? or questions.empty?
      teams.each do |team|
        users = TeamsUser.where(team_id: team.id).map(&:user)
        users.each do |user|
          tags = AnswerTag.where(tag_prompt_deployment_id: self.id, user_id: user.id, answer_id: answers.map(&:id))

          outliers = 0
          questions.each do |question|
            answer = answers.where(question_id: question.id)
            user_tag = tags.where(answer_id: answer.map(&:id))
            teammates = users.select {|e| e != user}
            unless teammates.empty?
              teammates_tags = AnswerTag.where(tag_prompt_deployment_id: self.id, user_id: teammates.map(&:id), answer_id: answer.map(&:id))
              if teammates_tags.uniq.size <= 1 && teammates_tags[0] != user_tag
                outliers += 1
              end
            end
          end
          if outliers > threshold
            outlier_user_ids.append(user.id)
          end
        end
      end
    end
    answer_tags = tags.where{|answer_tag| answer_tag.user_id != outlier_user_ids}
    answers = answers.select{|answer| answer.id != answer_tags.answer_id}
		answers
	end
end