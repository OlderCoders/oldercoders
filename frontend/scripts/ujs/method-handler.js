import Axios from "axios";
import NProgress from "nprogress";

const MethodHandler = {
  init() {
    document
      .querySelector("body")
      .addEventListener("click", this.handleClickEvent.bind(this));
    this.activeTriggers = [];
  },

  /**
   * Handles remote submission on links with a `data-remote` attribute
   * Bound to a 'click' event on the body and delegated to `a[data-remote]` links
   *
   * @param {Event} evt The event object - should be a submit event.
   */
  handleClickEvent(evt) {
    // Only left click allowed. Firefox triggers click event on right click/contextmenu.
    if (evt.button !== 0) {
      return;
    }

    const element = evt.target.closest("a[data-remote]");
    if (!element) {
      return;
    }
    evt.preventDefault();

    const opts = {
      url: element.getAttribute("href"),
      method: element.getAttribute("data-method"),
      responseType: element.getAttribute("data-response-type")
    };
    this.doRemoteRequest(opts, element);
  },

  /**
   * Does an XHR submission of a link.
   *
   * @param {Object} ops - The configuration for the remote request. Can pass in `url`, `method`, and `responseType` properties.
   * @param {Element} element - The element that triggered the request, if applicable.
   * @returns {Promise} The request promise.
   */
  doRemoteRequest(opts, element = null) {
    // Avoid double triggers
    if (element && this.activeTriggers.includes(element)) {
      return Promise.reject(new Error("Request already in progress"));
    }

    const xhrConfig = {
      url: opts.url,
      method: (opts.method || "get").toLowerCase(),
      responseType: (opts.responseType || "json").toLowerCase(),
      headers: {
        "X-Requested-With": "XMLHttpRequest",
        "X-Requested-By": "UJS"
      }
    };

    if (xhrConfig.responseType === "json") {
      xhrConfig.headers.Accept = "application/json";
    }

    // Mark the trigger as active
    if (element) {
      this.activeTriggers.push(element);
      element.classList.add("-loader");
    }

    return this.sendRequest(xhrConfig, element);
  },

  /**
   * Sends the remote request and sets up the default response handlers
   *
   * @param {Element} element The element (typically a link) that triggered the request
   * @param {Object} config The request configuration
   * @returns {Promise} The request promise.
   */
  sendRequest(config, element) {
    // Show the loader
    NProgress.start();

    // Do the request
    const request = Axios.request(config);

    // Set up the default response handlers
    // Note these are not chained so other `then` blocks will also receive the response argument.
    // For reference: https://github.com/axios/axios/issues/1057
    request
      .then(response => {
        this.handleResponse(response.data);
        this.releaseActiveTrigger(element);
        NProgress.done();
      })
      .catch(error => {
        // TODO - display an error to the account
        this.releaseActiveTrigger(element);
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
          target.innerHTML = block.html;
        } else {
          target.insertAdjacentHTML(block.insertion, block.html);
        }
      });
    });
  },

  releaseActiveTrigger(trigger) {
    if (!trigger) {
      return this.activeTriggers;
    }
    const index = this.activeTriggers.indexOf(trigger);
    if (index > -1) {
      trigger.classList.remove("-loader");
      return this.activeTriggers.splice(index, 1);
    }
    return [];
  }
};

export default MethodHandler;
