module ReservationsHelper

  def status(s)
    if s.approved?
      '<span class="glyphicon glyphicon-ok" title="Approved"></span>'
    elsif s.pending?
      '<span class="glyphicon glyphicon-refresh" title="Pending"></span>'
    else
      '<span class="glyphicon glyphicon-remove" title="Disapproved"></span>'
    end
  end

  def status_to_name(s)
    case s
    when 0
      'disapproved'
    when 1
      'pending'
    when 2
      'approved'
    end
  end

  def nice_changeset(name, change)
    case name
    when 'status'
      "Status changed from #{status_to_name(change[0])} to #{status_to_name(change[1])}"
    when 'count'
      if change[0].blank?
        "Reserved #{pluralize change[1], 'item'}"
      else
        "Reserved count changed from #{change[0]} to #{change[1]}"
      end
    when 'picked_up_count'
      "Picked up #{change[1] - change[0]}"
    when 'brought_back_count'
      "Brought #{change[1] - change[0]} back"
    end
  end

end
