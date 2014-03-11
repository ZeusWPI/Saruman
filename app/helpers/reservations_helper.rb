module ReservationsHelper

  def status(s)
    if s.approved?
      '<button class="btn btn-success btn-xs"><span class="glyphicon glyphicon-ok"> Approved</span></button>'
    elsif s.pending?
      '<button class="btn btn-warning btn-xs"><span class="glyphicon glyphicon-refresh"> Pending</span></button>'
    else
      '<button class="btn btn-danger btn-xs"><span class="glyphicon glyphicon-remove"> Disapproved</span></button>'
    end
  end

end
