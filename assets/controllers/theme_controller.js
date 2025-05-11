import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    connect() {
        document.documentElement.addEventListener('theme:active', (event) => this.activeThemeIcon(event));
        this.dispatchEvent('init');
    }

    next = () => {
        this.dispatchEvent('next');
    };

    activeThemeIcon = (event) => {
        this.element.querySelector('svg use').setAttribute('href', `#theme-icon-${event.detail.theme}`);

        const title = `Toggle theme (${event.detail.theme})`;
        this.element.setAttribute('aria-label', title);
        this.element.setAttribute('title', title);
    };

    dispatchEvent = (name) => {
        this.dispatch(name, { prefix: 'theme' });
    };
}
