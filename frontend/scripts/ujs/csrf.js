const CSRF = {
  token() {
    const token = document.querySelector('meta[name="csrf-token"]');
    return token && token.getAttribute("content");
  },
  param() {
    const param = document.querySelector('meta[name="csrf-param"]');
    return param && param.getAttribute("content");
  }
};

export default CSRF;
