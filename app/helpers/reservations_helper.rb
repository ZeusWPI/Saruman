module ReservationsHelper
  def status_colour(r)
    if r.approved?
      'success'
    elsif r.pending?
      'warning'
    else
      'danger'
    end
  end

  def returned_colour(r)
    if r.picked_up_count <= r.returned_count
      'success'
    else
      'danger'
    end
  end

  def status(r)
    if r.approved?
      '<i class="bi bi-check-lg"></i>'
    elsif r.pending?
      '<i class="bi bi-question-lg"></i>'
    else
      '<i class="bi bi-x-lg"></i>'
    end
  end

  def nice_changeset(name, change)
    case name
    when 'status'
      "Status changed from #{change[0]} to #{change[1]}"
    when 'count'
      if change[0].blank?
        "Reserved #{pluralize change[1], 'item'}"
      else
        "Reserved count changed from #{change[0]} to #{change[1]}"
      end
    when 'picked_up_count'
      "Picked up #{change[1] - change[0]}"
    when 'returned_used_count'
      "Returned #{change[1] - change[0]} used"
    when 'returned_unused_count'
      "Returned #{change[1] - change[0]} unused"
    end
  end

  def show_pickup_columns?
    return true if Date.current + 5.days > Settings.instance.event_date
    return true if Settings.instance.show_pickup_columns_in_reservations

    false
  end
end
