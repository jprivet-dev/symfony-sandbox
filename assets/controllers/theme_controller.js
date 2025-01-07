import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    connect() {
        super.connect();
        this.activeThemeIcon();
    }

    next = () => {
        nextTheme();
        this.activeThemeIcon();
    }

    activeThemeIcon = () => {
        this.element.querySelector('svg use').setAttribute('href', `#theme-icon-${getStoredTheme()}`);

        const title = `Toggle theme (${getStoredTheme()})`;
        this.element.setAttribute('aria-label', title);
        this.element.setAttribute('title', title);
    }
}
