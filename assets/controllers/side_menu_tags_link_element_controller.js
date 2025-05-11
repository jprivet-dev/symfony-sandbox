import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    connect() {
        document.addEventListener('swup:link:click', (event) => this.active(event));
    }

    active = (event) => {
        this.element.className = this.element === event.detail.args.el
            ? this.element.getAttribute('classes_current')
            : this.element.getAttribute('classes_default');
    }
}
