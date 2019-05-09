const debounce = (fn, time, immediate) => {
  let timeout;

  return function() {
    const functionCall = () => {
      timeout = null;
      if (!immediate) {
        fn.apply(this, arguments);
      }
    };

    const callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(functionCall, time);
    if (callNow) {
      fn.apply(this, arguments);
    }
  };
};

export default debounce;
