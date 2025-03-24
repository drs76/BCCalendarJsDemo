/*jshint esversion: 8 */
const bccalendar = new calendarJs();

function InitCalendar(options, widget) {
  setupCalendar(options, widget);
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

  properties.forEach((property) => {
    element.style.removeProperty(property);
  });
}

function setupCalendar(newOptions, widget) {
  const controlAddIn = document.getElementById("controlAddIn");
  bccalendar = new calendarJs(controlAddIn, {
    isWidget: widget,
    manualEditingEnabled: true,
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
        modEvent2BC(event);
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
  bccalendar.setOptions(newOptions, false);
}

function SetOptions(options) {
  bccalendar.setOptions(options);
}

function SetSearchOptions(options) {
  bccalendar.setSearchOptions(options);
}

function SetEvents(events) {
  bccalendar.setEventsFromJson(JSON.stringify(events));
  bccalendar.refresh();
}

async function getEvents() {
  const call = getALEventHandler("OnFetchEvents", false);
  const res = await call();
  bccalendar.setEventsFromJson(JSON.stringify(res || []));
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
  const call = getALEventHandler("OnAddEvent2BC", false);
  return await call(event);
}

async function modEvent2BC(event) {
  const call = getALEventHandler("OnModEvent2BC", false);
  return await call(event);
}

async function removeEventFromBC(event) {
  const call = getALEventHandler("RemoveEventFromBC", false);
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
