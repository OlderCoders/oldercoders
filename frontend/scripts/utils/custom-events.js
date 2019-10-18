const CustomEvents = {
  dispatch(type, bubbles = false, cancelable = false, el = document) {
    let evt;
    if (typeof Event === "function") {
      evt = new Event(type, { bubbles, cancelable });
    } else {
      evt = document.createEvent("Event");
      evt.initEvent(type, bubbles, cancelable);
    }
    el.dispatchEvent(evt);
  }
};

export default CustomEvents;
