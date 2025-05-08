import { Controller } from '@hotwired/stimulus';
import FragmentPlugin from '@swup/fragment-plugin';

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
        const postByTagElement = '#posts-by-tag';

        event.detail.options.plugins.push(new FragmentPlugin({
            debug: true,
            rules: [
                {
                    from: '/blog/tag/(.*)',
                    to: '/blog/tag(.*)',
                    containers: [postByTagElement],
                },
                {
                    from: '/blog/',
                    to: '/blog/tag(.*)',
                    containers: [postByTagElement],
                },
                {
                    from: '/blog/tag(.*)',
                    to: '/blog/',
                    containers: [postByTagElement],
                }
            ]
        }));
    }
}