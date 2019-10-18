import InputBinding from "./input-binding";
import debounce from "./debounce";
import CustomEvents from "./custom-events";

class Utils {
  constructor() {
    if (!Utils.instance) {
      Utils.instance = this;
    }

    document.addEventListener("DOMContentLoaded", () => {
      // Initialize input bindings
      document.querySelectorAll("input[data-bind-to]").forEach(input => {
        const binding = new InputBinding(input);
        Object.freeze(binding);
      });
    });

    return Utils.instance;
  }
}

const utils = new Utils();
Object.freeze(utils);

export { Utils, debounce, CustomEvents };
