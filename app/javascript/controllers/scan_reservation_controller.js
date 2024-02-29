import * as bootstrap from "bootstrap"
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
      this.pickUpTarget.classList.add("is-invalid")
      this.pickedUpWarningTarget.hidden = false
      this.#createOrUpdateTooltip(this.pickedUpWarningTarget, `Club can't pick up more than ${this.countValue - this.pickedUpValue} additional items`)
    } else {
      this.pickUpTarget.classList.remove("is-invalid")
      this.pickedUpWarningTarget.hidden = true
    }

    if(this.pickedUpValue + this.#pickUp() < 0) {
      this.pickUpTarget.classList.add("is-invalid")
      this.pickedUpWarningTarget.hidden = false
      this.#createOrUpdateTooltip(this.pickedUpWarningTarget, `Club only picked up ${this.pickedUpValue} items.`)
    }

    const missing = this.pickedUpValue - this.returnedUsedValue - this.returnedUnusedValue;
    if(this.#returnUsed() + this.#returnUnused() > missing) {
      this.returnUsedTarget.classList.add("is-invalid");
      this.returnUnusedTarget.classList.add("is-invalid");
      this.returnedWarningTarget.hidden = false;
      this.#createOrUpdateTooltip(this.returnedWarningTarget, `Club only picked up ${this.pickedUpValue} items.`)
    } else {
      this.returnUsedTarget.classList.remove("is-invalid");
      this.returnUnusedTarget.classList.remove("is-invalid");
      this.returnedWarningTarget.hidden = true;
    }

    if(this.#returnUsed() + this.returnedUsedValue < 0) {
      this.returnUsedTarget.classList.add("is-invalid");
      this.returnedWarningTarget.hidden = false;
      this.#createOrUpdateTooltip(this.returnedWarningTarget, `Club only brought back ${this.returnedUsedValue} used items.`)
    }

    if(this.#returnUnused() + this.returnedUnusedValue < 0) {
      this.returnUnusedTarget.classList.add("is-invalid");
      this.returnedWarningTargets.hidden = false;
      this.#createOrUpdateTooltip(this.returnedWarningTarget, `Club only brought back ${this.returnedUnusedValue} unused items.`)
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

  #createOrUpdateTooltip(element, content) {
    if (!bootstrap.Tooltip.getInstance(element)) {
      new bootstrap.Tooltip(element)
    }
    bootstrap.Tooltip.getInstance(element).setContent({ '.tooltip-inner': content })
  }
}
