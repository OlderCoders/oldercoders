import CSRF from "./csrf";
import ConfirmationHandler from "./confirmation-handler";
import FormHandler from "./form-handler";
import LinkHandler from "./link-handler";

class UJS {
  constructor() {
    if (!UJS.instance) {
      UJS.instance = this;
    }

    ConfirmationHandler.init();
    FormHandler.init();
    LinkHandler.init();

    return UJS.instance;
  }
}

const ujs = new UJS();
Object.freeze(ujs);

export default ujs;
export { FormHandler, LinkHandler, ConfirmationHandler, CSRF };
