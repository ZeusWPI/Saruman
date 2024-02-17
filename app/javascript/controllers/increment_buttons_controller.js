import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["valueField"]

  static values = {
    invalidWhenExceeds: Number
  }

  increment() {
    this.#setValue(this.#getValue() + 1);
    this.#updateWarning();
  }

  decrement() {
    this.#setValue(this.#getValue() - 1);
    this.#updateWarning();
  }

  #updateWarning() {
    console.log(this.invalidWhenExceedsValue)
    if (this.#getValue() > this.invalidWhenExceedsValue) {
      this.valueFieldTarget.classList.add('is-invalid');
    } else {
      this.valueFieldTarget.classList.remove('is-invalid');
    }
  }

  #getValue() {
    return parseInt(this.valueFieldTarget.value);
  }

  #setValue(value) {
    if(value < 0) return;

    this.valueFieldTarget.value = value;
  }
}
