import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    connect() {
        super.connect();
        activeThemeIcon(this.element);
    }

    next = () => {
        nextTheme();
        activeThemeIcon(this.element);
    }
}
