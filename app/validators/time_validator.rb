class TimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    Rails.logger.debug "Validate restaurant #{attribute} field"
    unless value =~ /^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/
      record.errors[attribute] << (options[:message] || "is not valid time")
    end
  end
end
