/*jshint esversion: 8 */
var bccalendar = new calendarJs();

function InitCalendar(options, widget) {
  setupCalendar(options, widget);
}

function setupCalendar(newOptions, widget) {
  bccalendar = new calendarJs(document.getElementById("controlAddIn"), {
    isWidget: widget,
    onOptionsUpdated: (options) => {
      syncOptionsBC(options);
    },
    onSearchOptionsUpdated: (searchOptions) => {
      syncSearchOptionsBC(searchOptions);
    },
    events: {
      onEventsFetch: () => {
        getEvents;
      },
      onEventAdded: (event) => {
        addEvent2BC(event);
      },
      onEventUpdated: (event) => {
        modEvent2BC(event);
      },
      onEventRemoved: (event) => {
        removeEventFromBC(event);
      },
    },
    useLocalStorageForEvents: false,
  });

  bccalendar.turnOnFullScreen();
  newOptions.isWidget = widget;
  SetOptions(newOptions);
}

function SetOptions(options) {
  bccalendar.setOptions(options, false);
}

function SetSearchOptions(options) {
  bccalendar.setSearchOptions(options);
}

function SetEvents(events) {
  bccalendar.setEventsFromJson(JSON.stringify(events));
  bccalendar.refresh();
}

function SetViewOptions(options) {
  bccalendar.SetViewOptions(options);
}

async function getEvents() {
  const call = getALEventHandler("OnFetchEvents", false);
  const res = await call();
  return (JSON.stringify(res || []));
  return (JSON.stringify(res || []));
}

async function syncOptionsBC(options) {
  const call = getALEventHandler("OnSyncOptionsBC", false);
  return await call(options);
}

async function syncSearchOptionsBC(options) {
  const call = getALEventHandler("OnSyncSearchOptionsBC", false);
  return await call(options);
}

async function addEvent2BC(event) {
  const call = getALEventHandler("OnModEvent2BC", false);
  return await call(event);
}

async function modEvent2BC(event) {
  const call = getALEventHandler("OnModEvent2BC", false);
  const res = await call(event);
  //bccalendar.updateEvent(event.id, res, true, false);
}

async function removeEventFromBC(event) {
  const call = getALEventHandler("OnRemoveEventFromBC", false);
  return await call(event);
}

function getALEventHandler(eventName, skipIfBusy) {
  return (...args) =>
    new Promise((resolve) => {
      const eRes = `${eventName}Result`;
      window[eRes] = (alRes) => {
        resolve(alRes);
        delete window[eRes];
      };

      Microsoft.Dynamics.NAV.InvokeExtensibilityMethod(
        eventName,
        args,
        skipIfBusy,
        () => { }
      );
    });
}
