import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  open(event) {
    event.preventDefault();

    const { params: { reservationId } } = event;

    $("#disapprove-id").val(reservationId);

    $("#disapprove-modal").modal("show");
  }

  close() {
    $("#disapprove-modal").modal("hide");
  }
}
