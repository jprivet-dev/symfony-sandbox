import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    connect() {
        this.select(this.current());
    }

    switch() {
        this.select(this.opposite(this.current()));
    }

    select (theme) {
        localStorage.setItem('user-theme', theme);
        document.documentElement.classList.add(theme);
        document.documentElement.classList.remove(this.opposite(theme));
    }

    current() {
        return localStorage.getItem('user-theme') || (document.documentElement.classList.contains('dark') ? 'dark' : 'light');
    }

    opposite(theme) {
        return theme === 'dark' ? 'light' : 'dark';
    }
}
