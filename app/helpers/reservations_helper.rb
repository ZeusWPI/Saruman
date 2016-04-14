module ReservationsHelper

  def row_colour(r)
    # Are we after the deadline?
    if not Settings.instance.deadline.nil? and Settings.instance.deadline < DateTime.now
      if r.approved?
        if (r.picked_up_count <= r.brought_back_count)
          'success'
        else
          'danger'
        end
      else
        'active'
      end
    # Reservation phase:
    else
      if r.approved?
        'success'
      elsif r.pending?
        'warning'
      else
        'danger'
      end
    end
  end

  def status(r)
    if r.approved?
      '<span class="glyphicon glyphicon-ok" title="Approved"></span>'
    elsif r.pending?
      '<span class="glyphicon glyphicon-refresh" title="Pending"></span>'
    else
      '<span class="glyphicon glyphicon-remove" title="Disapproved"></span>'
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
    when 'brought_back_count'
      "Brought #{change[1] - change[0]} back"
    end
  end

end
