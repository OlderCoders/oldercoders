import Axios from "axios";
import NProgress from "nprogress";
import serialize from "form-serialize";
import { debounce } from "scripts/utils";

const FormHandler = {
  init() {
    const typeAheadThreshold = 500; // Millisecond delay between on typeAhead submissions
    const body = document.querySelector("body");
    const typeAheadInputHandler = debounce(
      this.handleTypeAheadInput,
      typeAheadThreshold
    );

    body.addEventListener("submit", this.handleFormSubmission.bind(this));
    body.addEventListener("input", typeAheadInputHandler);

    window.addEventListener(
      "beforeunload",
      this.clearActiveTriggers.bind(this)
    );

    this.queryString = "";
    this.activeTriggers = [];

    // Forego the spinner on the progress bar.
    NProgress.configure({ showSpinner: false });
  },

  handleTypeAheadInput(evt) {
    const target = evt.target;
    if (!target || !target.matches("input[data-typeAhead]")) {
      return;
    }
    target.form.dispatchEvent(
      new Event("submit", {
        bubbles: true,
        cancelable: true
      })
    );
  },

  /**
   * Handles form submission, adding a loading indicator on the form's `<button type="submit">` element.
   * If the form has a `data-remote` attribute, it gets handed to the `doRemoteSubmission(method)`
   * Bound to a 'submit' event on the body.
   *
   * @param {Event} evt The event object - should be a submit event.
   * @param {Object} formData - Optional formData object. If omitted, will be constructed from the form input.
   * @returns If it's a remote submision, the remote request promise, otherwise null
   */
  handleFormSubmission(evt, formData) {
    if (evt.defaultPrevented) {
      return null;
    }

    const form = evt.target;
    const submit = form.querySelector('button[type="submit"]');

    if (submit && "classList" in submit) {
      submit.classList.add("-loader");
    }

    // Avoid double submits
    if (this.activeTriggers.includes(form)) {
      return null;
    }
    this.activeTriggers.push(form);

    if (form.matches("form[data-remote]")) {
      return this.doRemoteSubmission(evt, formData);
    }
    return null;
  },

  /**
   * Does an XHR submission of a form.
   *
   * @param {Event} evt - The event object. In this case, it's expecting a 'submit' event on a form.
   * @param {Object} formData - Optional formData object. If omitted, will be constructed from the form input.
   * @returns {Promise} The request promise.
   */
  doRemoteSubmission(evt, formData) {
    const form = evt.target;

    evt.preventDefault();

    const xhrConfig = {
      url: form.action,
      method: (
        form.method ||
        form.getAttribute("data-method") ||
        "post"
      ).toLowerCase(),
      responseType: (
        form.getAttribute("data-response-type") || "json"
      ).toLowerCase(),
      data: formData || new FormData(form),
      headers: {
        "X-Requested-With": "XMLHttpRequest",
        "X-Requested-By": "UJS"
      }
    };

    // FormData(form) doesn't work for get requests
    // Let's serialize the paramaeters
    if (xhrConfig.method === "get") {
      this.queryString = serialize(form);
      xhrConfig.url = `${form.action}?${this.queryString}`;
      // Make sure we record the URL when leaving the page.
      try {
        window.removeEventListener(
          "beforeunload",
          this.recordOutgoingURL.bind(this)
        );
      } catch (e) {
        // No need to die here if the event listner removal fails
      }
      window.addEventListener(
        "beforeunload",
        this.recordOutgoingURL.bind(this)
      );
    }

    if (xhrConfig.responseType === "json") {
      xhrConfig.headers.Accept = "application/json";
    }

    return this.sendRequest(form, xhrConfig);
  },

  /**
   * Sends the remote request and sets up the default response handlers
   *
   * @param {Element} form The form element which triggered the request
   * @param {Object} config The request configuration
   * @returns {Promise} The request promise.
   */
  sendRequest(form, config) {
    // Start the loading bar
    NProgress.start();

    // Do the request
    const request = Axios.request(config);

    // Set up the default response handlers
    // Note these are not chained so other `then` blocks will also recieve the response argument.
    // For reference: https://github.com/axios/axios/issues/1057
    request
      .then(response => {
        this.handleResponse(response.data);
        this.releaseActiveTrigger(form);
        NProgress.done();
      })
      .catch(error => {
        // TODO - display an error to the account
        this.releaseActiveTrigger(form);
        NProgress.done();
      });

    return request;
  },

  handleResponse(data) {
    if (data.redirect_to) {
      window.location.href = data.redirect_to;
      return;
    }
    this.updateContentBlocks(data.content);
  },

  updateContentBlocks(content) {
    if (!content) {
      return;
    }
    content.forEach(block => {
      const targets = document.querySelectorAll(block.target);
      if (!targets.length) {
        return;
      }
      targets.forEach(target => {
        if (block.insertion === "replace") {
          const activeElement = document.activeElement;
          let activeElementSelector = null;
          if (target.contains(activeElement)) {
            activeElementSelector = activeElement.tagName.toLowerCase();
            const type = activeElement.getAttribute("type");
            activeElementSelector += type ? `[type="${type}"]` : "";
          }
          target.innerHTML = block.html;
          if (activeElementSelector) {
            target.querySelector(activeElementSelector).focus();
          }
        } else {
          target.insertAdjacentHTML(block.insertion, block.html);
        }
      });
    });
  },

  formHasNoInputs(form) {
    const inputs = form.elements.filter(element => {
      const fieldType = element.nodeName.toUpperCase();
      if (
        element.disabled ||
        !element.hasAttribute("name") ||
        ((fieldType === "RADIO" || fieldType === "CHECKBOX") &&
          !element.checked)
      ) {
        return false;
      }
      return true;
    });
    return inputs.length === 0;
  },

  releaseActiveTrigger(trigger) {
    const index = this.activeTriggers.indexOf(trigger);
    if (index > -1) {
      const submit = trigger.querySelector('button[type="submit"]');
      if (submit && "classList" in submit) {
        submit.classList.remove("-loader");
      }
      return this.activeTriggers.splice(index, 1);
    }
    return [];
  },

  clearActiveTriggers() {
    this.activeTriggers.forEach(trigger => this.releaseActiveTrigger(trigger));
  },

  recordOutgoingURL() {
    if (this.queryString !== document.location.search.replace(/^\?/, "")) {
      const newUrl = document.location.href.replace(
        /\?(.*)$/,
        `?${this.queryString}`
      );
      window.history.replaceState({}, document.title, newUrl);
    }
  }
};

export default FormHandler;
