import { Controller } from '@hotwired/stimulus';

/**
 * See:
 * - https://symfony.com/bundles/ux-swup/current/index.html#extend-the-default-behavior
 * - https://swup.js.org/getting-started/demos/#fragment-support-modal
 * - https://glitch.com/edit/#!/swup-demo-fragment-list
 */
export default class extends Controller {
    connect() {
        this.element.addEventListener('swup:pre-connect', this.onPreConnect);
    }

    onPreConnect(event) {
        console.log(event.detail.options);
    }
}