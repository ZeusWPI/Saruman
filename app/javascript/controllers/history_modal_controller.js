import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  open() {
    $("#history-modal").modal("show");
  }

  close() {
    $("#history-modal").modal("hide");
  }
}
