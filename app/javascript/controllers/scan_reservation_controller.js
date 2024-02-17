import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["pickUp", "returnUsed", "returnUnused", "pickedUpWarning", "returnedWarning"]
  static values = {
    count: Number,
    pickedUp: Number,
    returnedUsed: Number,
    returnedUnused: Number
  }

  connect() {
    this.updateWarnings();
  }

  updateWarnings() {
    if(this.#pickUp() + this.pickedUpValue > this.countValue) {
      this.pickUpTarget.classList.add("is-invalid");
      this.pickedUpWarningTarget.hidden = false
    } else {
      this.pickUpTarget.classList.remove("is-invalid");
      this.pickedUpWarningTarget.hidden = true
    }

    const missing = this.pickedUpValue - this.returnedUsedValue - this.returnedUnusedValue;
    if(this.#returnUsed() + this.#returnUnused() > missing) {
      this.returnUsedTarget.classList.add("is-invalid");
      this.returnUnusedTarget.classList.add("is-invalid");
      this.returnedWarningTargets.forEach((target) => target.hidden = false);
    } else {
      this.returnUsedTarget.classList.remove("is-invalid");
      this.returnUnusedTarget.classList.remove("is-invalid");
      this.returnedWarningTargets.forEach((target) => target.hidden = true);
    }
  }

  #pickUp() {
    return parseInt(this.pickUpTarget.value);
  }

  #returnUsed() {
    return parseInt(this.returnUsedTarget.value);
  }

  #returnUnused() {
    return parseInt(this.returnUnusedTarget.value);
  }
}
