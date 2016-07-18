class ReservationIntervalValidator < ActiveModel::Validator
  def validate(record)
    Rails.logger.debug "Validate reservation interval:"

    unless record.start_at.nil? || record.end_at.nil?
      correct_interval record
      restaurant_time_work_matching record
      time_intersection record
    else
      Rails.logger.debug record.errors.full_messages.join(". ")
      record.errors[:start_at] << "can't be blank" if record.start_at.nil?
      record.errors[:end_at] << "can't be blank" if record.end_at.nil?
    end

  end

  private

  # validate end_at must be greater than start at
  def correct_interval(record)
    Rails.logger.debug "Validate correct interval"

    unless record.start_at < record.end_at
      record.errors[:end_at] << "must be greater than start at"
    end
  end

  # validate start_at and end_at to be in restaurant time work interval
  def restaurant_time_work_matching(record)
    Rails.logger.debug "Validate restaurant time work matching"
    message = "is not in restaurant operating time"

    return if check_restaurant_not_exists(record)

    # check intervals is unnecessary when checked by duration
    check_time_matching_by_duration(record, message) ||
      check_time_matching_by_intervals(record, message)
  end

  def check_restaurant_not_exists(record)
    if record.restaurant.nil?
      record.errors[:reservation] << "must relate to any restaurant"
    end
  end

  # check if reservation duration is more than 24 hours when restaurnt
  # works not around the clock.
  # returns true if check is complited
  def check_time_matching_by_duration(record, message)
    return true if record.restaurant.is_around_the_clock?

    if (record.end_at - record.start_at) / (60 * 60 * 24) >= 1
      record.errors[:end_at] << message
      true
    end
  end

  # compare reservation interval with restaurant's open hours
  def check_time_matching_by_intervals(record, message)
    reservation_start_at = record.start_at.strftime("%H:%M")
    reservation_end_at = record.end_at.strftime("%H:%M")

    if record.restaurant.open_at < record.restaurant.close_at

      if reservation_start_at < record.restaurant.open_at ||
        reservation_start_at > record.restaurant.close_at
        record.errors[:start_at] << message
      end
      if reservation_end_at < record.restaurant.open_at ||
        reservation_end_at > record.restaurant.close_at
        record.errors[:end_at] << message
      end

    else

      if reservation_start_at < record.restaurant.open_at &&
        reservation_start_at > record.restaurant.close_at
        record.errors[:start_at] << message
      end

      if reservation_end_at < record.restaurant.open_at &&
        reservation_end_at > record.restaurant.close_at
        record.errors[:end_at] << message
      end

    end
  end

  # validate reservation not intersects with another
  def time_intersection(record)
    Rails.logger.debug("Validate time intersection with another reservation")

    if Reservation.where(:table_id => record.table_id)
      .where(
        "(start_at, end_at) OVERLAPS (?, ?)", record.start_at, record.end_at
      ).count > 0

      record.errors[:reservation] << (options[:message] ||
       "intersects with another reservation")
    end
  end
end
