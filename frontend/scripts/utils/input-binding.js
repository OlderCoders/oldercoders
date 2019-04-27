class InputBinding {
  constructor(inp) {
    if (!inp && inp.tagName !== 'INPUT') {
      return;
    }
    this.input = inp;
    this.bindings = document.querySelectorAll(this.input.dataset.bindTo);

    this.input.addEventListener('input', this.updateBindings.bind(this));
  }

  updateBindings() {
    this.bindings.forEach(binding => {
      binding.innerText = this.input.value;
    });
  }
}

export default InputBinding;
