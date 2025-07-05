import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    connect() {
        document.addEventListener('swup:link:click', (event) => this.active(event));
    }

    active = (event) => {
        this.element.className = this.element.getAttribute('href') === this.getNextPathnameFromSwupEvent(event)
            ? this.element.getAttribute('classes_active')
            : this.element.getAttribute('classes_default');
    }

    getNextPathnameFromSwupEvent = (event) => {
        const origin = (new URL(window.location.href)).origin;
        return (new URL(`${origin}${event.detail.visit.to.url}`)).pathname;
    }
}
