class QualityFiltering
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
			answers = self.apply_outlier_filter(answers)
		end
		answers
	end

	# Filter out all answers with comment length less than a set threshold
	def apply_threshold_filter(answers, threshold)
		answers = answers.select{|answer| answer.comments.split(' ').length > threshold}
	end

	def apply_outlier_filter(answers) 
		# For Sichao to implement
		answers
	end
end