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
        document.addEventListener('swup:pre-connect', this.onPreConnect);
    }

    onPreConnect(event) {
        event.detail.options.plugins.push(new FragmentPlugin({
            debug: true,
            rules: [{
                from: ['/blog/posts-by-tag/:id', '/blog/posts-by-tag/'],
                to: ['/blog/posts-by-tag/:id', '/blog/posts-by-tag/'],
                containers: ['#posts-by-tag'],
                scroll: '#posts-by-tag',
            }]
        }));
    }
}