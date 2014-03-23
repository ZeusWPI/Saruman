module ReservationsHelper

  def status(s)
    if s.approved?
      '<span class="glyphicon glyphicon-ok"> Approved</span>'
    elsif s.pending?
      '<span class="glyphicon glyphicon-refresh"> Pending</span>'
    else
      '<span class="glyphicon glyphicon-remove"> Disapproved</span>'
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
      "Count changed from #{change[0]} to #{change[1]}"
    end
  end

end
