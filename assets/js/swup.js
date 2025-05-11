function getNextPathnameFromSwupEvent(event) {
    const origin = (new URL(window.location.href)).origin;
    return (new URL(`${origin}${event.detail.visit.to.url}`)).pathname;
}

export { getNextPathnameFromSwupEvent }