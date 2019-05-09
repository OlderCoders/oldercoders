import ConfirmationHandler from "./confirmation-handler";
import FormHandler from "./form-handler";
import MethodHandler from "./method-handler";

class UJS {
  constructor() {
    if (!UJS.instance) {
      UJS.instance = this;
    }

    ConfirmationHandler.init();
    FormHandler.init();
    MethodHandler.init();

    return UJS.instance;
  }
}

const ujs = new UJS();
Object.freeze(ujs);

export default ujs;
export { FormHandler, MethodHandler, ConfirmationHandler };
