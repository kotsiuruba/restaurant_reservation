class ReservationIntervalValidator < ActiveModel::Validator

  def validate(record)
    Rails.logger.debug "Validate reservation interval:"

    if !record.start_at.nil? && !record.end_at.nil?
      correct_interval record
      restaurant_time_work_matching record
      time_intersection record
    else
        record.errors[:start_at] << ("can't be blank") if record.start_at.nil?
        record.errors[:end_at] << ("can't be blank") if record.end_at.nil?
    end

    Rails.logger.debug record.errors.full_messages.join(". ")
  end

  private

  def correct_interval(record)
    Rails.logger.debug "Validate correct interval"

    if  !(record.start_at < record.end_at)
      record.errors[:end_at] << ("must be greater than start at")
    end
  end

  def restaurant_time_work_matching(record)

    Rails.logger.debug("Validate restaurant time work matching")

    if record.restaurant.nil?
      return record.errors[:reservation] << "must relate to any restaurant"
    end

    reservation_start_at, reservation_end_at = record.start_at.strftime("%H:%M"), record.end_at.strftime("%H:%M")
    message = "is not in restaurant operating time"

    if record.restaurant.open_at < record.restaurant.close_at

      if reservation_start_at < record.restaurant.open_at || reservation_start_at > record.restaurant.close_at
        record.errors[:start_at] << (message)
      end
      if reservation_end_at < record.restaurant.open_at || reservation_end_at > record.restaurant.close_at
        record.errors[:end_at] << (message)
      end

    else

      if reservation_start_at < record.restaurant.open_at && reservation_start_at > record.restaurant.close_at
        record.errors[:start_at] << (message)
      end

      if reservation_end_at < record.restaurant.open_at && reservation_end_at > record.restaurant.close_at
        record.errors[:end_at] << (message)
      end

    end
  end

  def time_intersection(record)

    Rails.logger.debug("Validate time intersection with another reservation")

    if Reservation.where(:table_id => record.table_id).where("(start_at, end_at) OVERLAPS (?, ?)", record.start_at, record.end_at).count > 0
      record.errors[:reservation] << (options[:message] || "intersects with another reservation")
    end
  end

end
