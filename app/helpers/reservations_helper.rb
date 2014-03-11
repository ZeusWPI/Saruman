module ReservationsHelper

  def approved(r)
    if r.approved
      '<button class="btn btn-success btn-xs"><span class="glyphicon glyphicon-ok"> Approved</span></button>'
    else
      '<button class="btn btn-warning btn-xs"><span class="glyphicon glyphicon-remove"> Waiting</span></button>'
    end
  end

end
