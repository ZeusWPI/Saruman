import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  open() {
    console.log("Sup")
    $("#history-modal").modal("show");
  }

  close() {
    console.log("Sup closing")
    $("#history-modal").modal("hide");
  }
}
