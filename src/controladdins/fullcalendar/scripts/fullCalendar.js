/*jshint esversion: 8 */
let setup;
let bccalendar;
let draggable;

function InitCalendar(settings, enableDraggable) {
    setup = settings;
    setupIFrame();
    setupControlAddIn(enableDraggable);
    setupCalendar();
    alert('7');
}

function setupIFrame() {
    let iframe = window.frameElement;

    applyFlexStyles(iframe.parentElement, ['flex-direction', 'column', '1']);
    applyFlexStyles(iframe, ['height'], '99%');
    removeStyles(iframe, ['min-height', 'max-height']);
    applyFlexStyles(iframe, ['flex-grow', 'flex-shrink', 'flex-basis'], ['1', '1', 'auto']);
    iframe.style.paddingBottom = '42px';
}

function applyFlexStyles(element, properties, values) {
    if (!Array.isArray(properties)) properties = [properties];
    if (!Array.isArray(values)) values = [values];

    properties.forEach((property, index) => {
        element.style.setProperty(`flex-${property}`, values[index]);
    });
}

function removeStyles(element, properties) {
    if (!Array.isArray(properties)) properties = [properties];

    properties.forEach(property => {
        element.style.removeProperty(property);
    });
}

function setupControlAddIn(enableDraggable) {
    let controlAddIn = document.getElementById("controlAddIn");

    let calendarContainer = createDiv();
    calendarContainer.id = 'calendar-container';
    calendarContainer.innerHTML = '';

    let calendarElement = createDiv();
    calendarElement.id = 'calendar';
    calendarElement.innerHTML = '';

    calendarContainer.appendChild(calendarElement);
    controlAddIn.appendChild(calendarContainer);
}

function createDiv() {
    let newDiv = document.createElement('div');
    applyFlexStyles(newDiv, ['height', 'flex-grow', 'flex-shrink', 'flex-basis'], ['99%', '1', '1', 'auto']);
    return newDiv;
}

function setupDraggable() {
    let externalEvents = document.getElementById("external-events");

    draggable = new bccalendar.Draggable(externalEvents, {
        itemSelector: '.fc-event',
        eventData: function (eventEl) {
            return {
                title: eventEl.innerText
            };
        },
    });
}

function setupCalendar() {
    var calendarEl = document.getElementById("calendar");
    bccalendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        themeSystem: 'flatly',
    });
    bccalendar.render();

    alert('ok');
}