const ConfirmationHandler = {
  init() {
    const body = document.querySelector('body');
    body.addEventListener('click', this.doConfirmation, true);
    body.addEventListener('submit', this.doConfirmation, true);
  },

  doConfirmation(e) {
    const target = e.target;
    if (!target.dataset || !target.dataset.confirm) {
      return;
    }

    // eslint-disable-next-line no-alert
    if (!window.confirm(target.dataset.confirm)) {
      e.preventDefault();
      e.stopPropagation();
    }
  }
};

export default ConfirmationHandler;
