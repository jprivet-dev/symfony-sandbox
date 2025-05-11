import { Controller } from '@hotwired/stimulus';
import { getNextPathnameFromSwupEvent } from '../js/swup.js';

export default class extends Controller {
    connect() {
        document.addEventListener('swup:link:click', (event) => this.active(event));
    }

    active = (event) => {
        this.element.className = this.element.getAttribute('href') === getNextPathnameFromSwupEvent(event)
            ? this.element.getAttribute('classes_active')
            : this.element.getAttribute('classes_default');
    }
}
