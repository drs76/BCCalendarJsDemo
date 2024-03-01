/*jshint esversion: 8 */
let setup;
let bccalendar;
let draggable;


function InitCalendar(settings, enableDraggable) {
    setup = settings;
    setupIFrame();
    setupControlAddIn(enableDraggable);
    setupCalendar();

    //if (enableDraggable) {
        //setupDraggable();
    //}
    alert('7');
}

function setupIFrame() {
    let iframe = window.frameElement;

    setFlexStyles(iframe.parentElement, ['flex-direction', 'column', '1']);
    setFlexStyles(iframe, ['height'], '100%');
    removeStyles(iframe, ['min-height', 'max-height']);
    setFlexStyles(iframe, ['flex-grow', 'flex-shrink', 'flex-basis'], ['1', '1', 'auto']);
    iframe.style.paddingBottom = '42px';
}

function setFlexStyles(element, properties, values) {
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

    // if (enableDraggable) {
    //     let hHeader = document.createElement("h4");
    //     hHeader.textContent = setup.dragEventTitle;
    //     controlAddIn.appendChild(hHeader);

    //     let externalEvents = document.createElement('div');
    //     externalEvents.id = 'external-events';
    //     externalEvents.innerHTML = '';
    //     controlAddIn.appendChild(externalEvents);

    //     populateExternalEvents();
    // }

    let calendarContEl = createDiv();
    calendarContEl.id = 'calendar-container';
    calendarContEl.innerHTML = '';

    let calendarEl = createDiv();
    calendarEl.id = 'calendar';
    calendarEl.innerHTML = '';

    calendarContEl.appendChild(calendarEl);
    controlAddIn.appendChild(calendarContEl);
}

function createDiv() {
    let newDiv = document.createElement('div');
    setFlexStyles(newDiv, ['height', 'flex-grow', 'flex-shrink', 'flex-basis'], ['100%', '1', '1', 'auto']);
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
    var bccalendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth'
    });
    bccalendar.render();

    alert('ok');
}