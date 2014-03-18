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

end
