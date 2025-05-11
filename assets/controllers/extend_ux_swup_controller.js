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
                // TODO: Error: [swup] Error parsing path "/blog/tag/,/blog{/*?page=},/blog/":
                //  See https://github.com/pillarjs/path-to-regexp#errors
                // from: ['/blog/tag/(.*)', '/blog/(.*)?page=(.*)', '/blog/'],
                // to: ['/blog/tag/(.*)', '/blog/(.*)?page=(.*)', '/blog/'],
                from: ['/blog/'],
                to: ['/blog/'],
                containers: ['#posts-by-tag'],
                scroll: '#posts-by-tag',
            }]
        }));
    }
}