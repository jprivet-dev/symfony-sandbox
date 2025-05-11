import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    connect() {
        document.addEventListener('swup:link:click', (event) => this.active(event));
    }

    active = (event) => {
        const isNotUrlBlog = this.element.getAttribute('href') !== '/blog/';
        const restInSameUrlTag = event.detail.visit.to.url.search(this.element.getAttribute('href')) === 0;
        const forceActive = isNotUrlBlog && restInSameUrlTag;

        this.element.className = this.element === event.detail.args.el || forceActive
            ? this.element.getAttribute('classes_current')
            : this.element.getAttribute('classes_default');
    }
    k
}
