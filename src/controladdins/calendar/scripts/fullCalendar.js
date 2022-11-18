/*jshint esversion: 8 */
var setup;
var calendar;
var draggable;

// initialize the calendar page for first time
function InitCalendar(settings, enableDraggable) {
    setup = settings;

    // set the default close and far colors for CSS, frm setup fields.
    if (setup.defaultCloseColor) {
        if (isValidColor(setup.defaultCloseColor)) {
            document.body.style.setProperty('--close-color', nameToColor(setup.defaultCloseColor));
        }
    }

    if (setup.defaultFarColor) {
        if (isValidColor(setup.defaultFarColor)) {
            document.body.style.setProperty('--far-color', nameToColor(setup.defaultFarColor));
        }
    }

    if (setup.defaultAmberColor) {
        if (isValidColor(setup.defaultAmberColor)) {
            document.body.style.setProperty('--amber-color', nameToColor(setup.defaultAmberColor));
        }
    }

    setupIFrame();
    setupControlAddIn(enableDraggable);
    setupCalendar();

    if (enableDraggable) {
        setupDraggable();
    }
}

// setup the iFrame that the controlAddIn sits in.
function setupIFrame() {
    let iframe = window.frameElement;

    iframe.parentElement.style.display = 'flex';
    iframe.parentElement.style.flexDirection = 'column';
    iframe.parentElement.style.flexGrow = '1';

    iframe.style.height = "100%";
    iframe.style.removeProperty('min-height');
    iframe.style.removeProperty('max-height');

    iframe.style.flexGrow = '1';
    iframe.style.flexShrink = '1';
    iframe.style.flexBasis = 'auto';
    iframe.style.paddingBottom = '42px';
}

// setup the controlAddIn on the HTML page
function setupControlAddIn(enableDraggable) {
    let controlAddIn = document.getElementById("controlAddIn");

    if (enableDraggable) {
        let hHeader = document.createElement("h4");
        hHeader.textContent = setup.dragEventTitle;
        controlAddIn.appendChild(hHeader);

        let externalEvents = document.createElement('div');
        externalEvents.id = 'external-events';
        externalEvents.innerHTML = '';
        controlAddIn.appendChild(externalEvents);

        populateExternalEvents();
    }

    let calendarContEl = createDiv();
    calendarContEl.id = 'calendar-container';
    calendarContEl.innerHTML = '';

    let calendarEl = createDiv();
    calendarEl.id = 'calendar';
    calendarEl.innerHTML = '';

    calendarContEl.appendChild(calendarEl);
    controlAddIn.appendChild(calendarContEl);
}

// create a div on the page
function createDiv() {
    let newDiv = document.createElement('div');
    newDiv.style.height = "100%";
    newDiv.style.removeProperty('min-height');
    newDiv.style.removeProperty('max-height');
    newDiv.style.flexGrow = '1';
    newDiv.style.flexShrink = '1';
    newDiv.style.flexBasis = 'auto';
    return newDiv;
}

// add the external events (draggable) to the page
function setupDraggable() {
    let externalEvents = document.getElementById("external-events");

    draggable = new FullCalendar.Draggable(externalEvents, {
        itemSelector: '.fc-event',
        eventData: function (eventEl) {
            return {
                title: eventEl.innerText
            };
        },
    });
}

// add the calendar to the page
function setupCalendar() {
    let calendarEl = document.getElementById("calendar");

    calendar = new FullCalendar.Calendar(calendarEl, {
        schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
        headerToolbar: {
            left: 'prev,next,today,changeViewButton',
            center: 'title',
            right: setup.headerRight
        },
        views: {
            resourceTimeGrid2Day: {
                buttonText: '2 days',
                type: 'resourceTimeGridDay',
                duration: { days: 2 },
                resourceGroupField: 'id'
            },
        },
        customButtons: {
            changeViewButton: {
                text: 'Switch ' + (setup.defaultView.startsWith('resourceTimeline') ? 'Agenda' : 'Timeline'),
                click: function () {
                    SetDefaultView();
                }
            }
        },
        resources: function (info, successCallback, failureCallback) {
            getResources(info).then((returnResources) => {
                successCallback(returnResources);
            }).catch((error) => {
                failureCallback(error);
            });
        },
        resourceLabelDidMount: function (info) {
            // resource label styling.
            info.el.style.backgroundColor = info.resource.extendedProps.backgroundColor;
            info.el.style.height = setup.resourceHeight;
        },
        events: function (info, successCallback, failureCallback) {
            getEvents(info).then((returnEvents) => {
                successCallback(returnEvents);
            }).catch((error) => {
                failureCallback(error);
            });
        },
        drop: function (info) {
            // The resource will only be available if the view supports it.
            if (info.hasOwnProperty('resource')) {
                let currEvent = { id: info.draggedEl.innerText, resourceId: info.resource.id, title: info.draggedEl.title, start: info.date, end: info.date, allDay: info.allDay, backgroundColor: info.resource.extendedProps.backgroundColor };
                if (!addDraggedOrder(info, JSON.stringify(currEvent))) {
                    info.revert();
                }
            } else {
                info.revert();
            }
        },
        eventReceive: function (info) {
            info.revert(); // we are handling the dragged event, don't let the calendar add its own.
        },
        eventClick: function (info) {
            let event = calendar.getEventById(info.event.id);
            let resource = calendar.getResourceById(event._def.resourceIds[0]);
            let currEvent;
            currEvent = createEvent(info.event.id, resource.id, info.event.title, setUndefinedDate(event.start, event._context.currentDate), setUndefinedDate(event.end, event._context.currentDate), event.allDay, setUndefinedString(resource._resource.ui.backgroundColor, ''), setUndefinedString(event.textColor, setup.eventsTextColor));

            editInBC(JSON.stringify(currEvent), false);
        },
        dateClick: function (info) {
            info.jsEvent.preventDefault(); // don't let the browser navigate
            if (setup.allowedToAddEvents === true) {
                let newEvent = createEvent('', info.resource.id, '', new Date(info.dateStr), new Date(info.dateStr), true, setUndefinedString(resource._resource.ui.backgroundColor, ''), setUndefinedString(info.textColor, setup.eventsTextColor));
                editInBC(JSON.stringify(newEvent), true);
            }
        },
        eventDrop: function (info) {
            alert(info.event.title + " was dropped on " + info.event.start.toISOString());
            let currEvent = createEvent(info.event.id, info.event.resourceId, info.event.title, info.event.start, info.event.end, info.event.allDay, setUndefinedString(info.event.backgroundColor, ''), setUndefinedString(info.event.textColor, setup.eventsTextColor));
            if (!sendCalendarUpdateToBC(JSON.stringify(currEvent))) {
                info.revert();
            }
        },
        eventResize: function (info) {
            let currEvent = createEvent(info.event.id, info.event.resourceId, info.event.title, info.event.start, info.event.end, info.event.allDay, setUndefinedString(info.event.backgroundColor, ''), setUndefinedString(info.event.textColor, setup.eventsTextColor));
            if (!sendCalendarUpdateToBC(JSON.stringify(currEvent))) {
                info.revert();
            }
        },
        eventDidMount: function (info) {
            if (info.isDragging) {
                setDragBG(info);
            } else {
                if (info.event.textColor) {
                    info.el.style.color = info.event.textColor;
                }
                if (info.event.extendedProps.tooltip) {
                    info.el.setAttribute('title', info.event.extendedProps.tooltip); // tooltip basic
                }
                info.el.setAttribute('data-event-id', info.event.id); // used to identify the html element for the event.
            }
        },
        eventWillUnmount: function (info) {
            if (info.isDragging) {
                unSetDragBG(info);
            }
        },
        initialView: setup.defaultView,
        // navLinks: setup.navLinks,
        resourceAreaWidth: setup.resourceAreaWidth,
        resourceAreaHeaderContent: setup.resourceHeading,
        editable: setup.editable,
        businessHours: setup.businessHours,
        droppable: setup.droppable, // this allows things to be dropped onto the calendar
        dayMaxEvents: true, // when too many events in a day, show the popover
        dayMinWidth: 200,
        datesAboveResources: true,
        selectable: true,
        weekNumbers: true,
        height: "95%",
        handleWindowResize: true,
        aspectRatio: 1.5,
        slotDuration: setup.slotDurationMinutes,
        defaultTimedEventDuration: setup.slotDurationMinutes,
        forceEventDuration: true,
        displayEventTime: true,
        displayEventEnd: true,
        eventTextColor: setup.eventsTextColor,
        slotMinTime: setup.minTime,
        slotMaxTime: setup.maxTime,
        allDaySlot: setup.allDaySlot,
        themeSystem: "bootstrap5"
    });

    calendar.render();
}

function setUndefinedDate(checkDate, defaultDate) {
    return checkDate ? checkDate : defaultDate;
}

function setUndefinedString(checkString, defaultString) {
    return checkString ? checkString : defaultString;
}

// change the default view on the calendar.
function SetDefaultView() {
    switch (calendar.view.type) {
        case 'resourceTimelineDay':
            if (setup.enable2DateView) {
                setup.defaultView = 'resourceTimeGrid2Day';
            } else {
                setup.defaultView = 'resourceTimeGridDay';
            }
            break;
        case 'resourceTimelineWeek':
            setup.defaultView = 'resourceTimeGridWeek';
            break;
        case 'resourceTimelineMonth':
            setup.defaultView = 'dayGridMonth';
            break;
        case 'resourceTimeGrid2Day':
            setup.defaultView = 'resourceTimelineDay';
            break;
        case 'resourceTimeGridDay':
            setup.defaultView = 'resourceTimelineDay';
            break;
        case 'resourceTimeGridWeek':
            setup.defaultView = 'resourceTimelineWeek';
            break;
        case 'dayGridMonth':
            setup.defaultView = 'resourceTimelineMonth';
            break;
    }

    if (setup.defaultView.startsWith('resourceTimeline')) {
        setup.headerRight = 'resourceTimelineDay,resourceTimelineWeek,resourceTimelineMonth';
    } else {
        switch (setup.enable2DateView) {
            case true:
                setup.headerRight = 'resourceTimeGrid2Day,resourceTimeGridWeek,dayGridMonth';
                break;
            case false:
                setup.headerRight = 'resourceTimeGridDay,resourceTimeGridWeek,dayGridMonth';
                break;
            default:
                setup.headerRight = 'resourceTimeGridDay,resourceTimeGridWeek,dayGridMonth';
                break;
        }
    }

    calendar.changeView(setup.defaultView, calendar.view.currentStart);
}

// create an event object
function createEvent(eId, eResourceId, eTitle, eStart, eEnd, eAllDay, eBackgroundColor, eTextColor) {
    let e = { id: eId, resourceId: eResourceId, title: eTitle, start: eStart, end: eEnd, allDay: eAllDay, backgroundColor: eBackgroundColor, textColor: eTextColor };
    return e;
}

// set the initial date the calendar loads to.
function SetInitialDate(initialDate) {
    calendar.gotoDate(initialDate);
}

// refetch the resources and events (called after updates).
function refetchEvents() {
    calendar.batchRendering(function () {
        calendar.refetchResources();
        calendar.refetchEvents();
    });
}

// edit an existing calendar event in AL, event clicked on calendar
async function editInBC(event, adding) {
    let call = getALEventHandler("OpenCalendarEntry", false); // get handler for extensibility
    let res = await call(event, adding);
    if (applyUpdate(res)) {
        calendar.refetchEvents();
    }
}

// add an external event to the calendar.
async function addDraggedOrder(info, event) {
    let call = getALEventHandler("HandleExternalDraggedEvent", false);
    let res = await call(event);
    if (applyUpdate(res)) {
        info.draggedEl.parentNode.removeChild(info.draggedEl); // remove from draggable as it has been added.
        calendar.refetchEvents();
    }
}

// check return value to see if update required.
function applyUpdate(res) {
    if (res == null) {
        return (false);
    }
    return (res.update);
}

// send an event change to AL for update.
async function sendCalendarUpdateToBC(event) {
    console.log(event.start);
    let call = getALEventHandler("UpdateBCWithCalendarEntry", false);
    let res = await call(event);
    if (res !== null) {
        if (res.success == true) {
            return true;
        }
    }
    return false;
}

// get the event JsonArray from AL
async function getEvents(fetchInfo) {
    console.log(fetchInfo);
    let call = getALEventHandler("GetEvents", false);
    let res = await call(fetchInfo);
    if (res === null) {
        res = [];
    }
    return res;
}

// get the resource JsonArray from AL
async function getResources(fetchInfo) {
    let call = getALEventHandler("GetResources", false);
    let res = await call(fetchInfo);
    if (res === null) {
        res = [];
    }
    return res;
}

// get return value from AL trigger or proc
function getALEventHandler(eventName, skipIfBusy) {
    return (...args) => new Promise(resolve => {
        let res;

        let eRes = `${eventName}Result`;
        window[eRes] = alRes => {
            res = alRes;
            delete window[eRes];
        };

        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod(
            eventName,
            args,
            skipIfBusy,
            () => resolve(res));
    });
}

// load the external events to page
function populateExternalEvents() {
    if (setup.extEvents == null) {
        return;
    }
    setup.extEvents.forEach(loadExternalEvent);
}

// create the HTML for external events
function loadExternalEvent(item) {
    let de = document.createElement('div');
    let dm = document.createElement('div');

    de.setAttribute('class', 'fc-event fc-h-event fc-daygrid-event fc-daygrid-block-event');
    de.setAttribute('draggable', true);

    dm.setAttribute('class', 'fc-event-main');
    if (item.extendedProps.tooltip) {
        de.setAttribute('title', item.extendedProps.tooltip);
    }
    dm.innerHTML = `<strong>${item.title}</strong>`;
    dm.id = `${item.id}`;
    dm.setAttribute('event', item);

    de.appendChild(dm);
    document.getElementById('external-events').appendChild(de);
}

// set the near & far colours
function setDragBG(info) {
    if (!setup.dragColorSettings) {
        return;
    }

    let item = setup.extEvents.find(item => item.id === info.event.title);
    if (item == null) {
        return;
    }

    calendar.getEvents().forEach(event => {
        var el = document.querySelector('[data-event-id="' + event.id + '"]'),
            s = el.style;
        if (event.extendedProps.postcode === item.extendedProps.postcode) {
            el.classList.add('close');
            el.classList.remove('far');
            el.classList.remove('amber');
        } else {
            let i = setup.dragColorSettings.findIndex(function (e) {
                return e["postcode1"] === item.extendedProps.postcode || e["postcode2"] === item.extendedProps.postcode;
            });
            let c = -1 === i ? setup.defaultFarColor : setup.dragColorSettings[i].color;
            var el = document.querySelector('[data-event-id="' + event.id + '"]');
            switch (c) {
                case setup.defaultFarColor:
                    el.classList.add('far');
                    el.classList.remove('close');
                    el.classList.remove('amber');
                    break;
                case setup.defaultCloseColor:
                    el.classList.add('close');
                    el.classList.remove('far');
                    el.classList.remove('amber');
                    break;
                default:
                    el.classList.add('amber');
                    el.classList.remove('far');
                    el.classList.remove('close');
            }
            console.log(el);
        }
    });
}

// remove near & far colours
function unSetDragBG(info) {
    if (info.isDragging) {
        calendar.getEvents().forEach(event => {
            var el = document.querySelector('[data-event-id="' + event.id + '"]');
            if (el) {
                el.classList.remove('close');
                el.classList.remove('far');
                el.classList.remove('amber');
            }
        });
    }
}

// validate the colour
function isValidColor(strColor) {
    var s = new Option().style;
    s.color = strColor;
    // return 'false' if color wasn't assigned
    return s.color == strColor.toLowerCase();
}

// return the actual color
function nameToColor(strColor) {
    var s = new Option().style;
    s.color = strColor;
    return s.color;
}