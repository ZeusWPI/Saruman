import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["valueField"]

  increment() {
    this.#setValue(this.#getValue() + 1);
  }

  decrement() {
    this.#setValue(this.#getValue() - 1);
  }

  #getValue() {
    return parseInt(this.valueFieldTarget.value) || 0;
  }

  #setValue(value) {
    this.valueFieldTarget.value = value;

    // Trigger an input event manually so that we can act on value changes
    this.valueFieldTarget.dispatchEvent(
      new Event(
        'input',
        {bubbles: true , cancelable: true}
      )
    );
  }
}
