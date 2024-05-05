/*jshint esversion: 8 */
var bccalendar;
var draggable;

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
  let controlAddIn = document.getElementById("controlAddIn");
  bccalendar = new calendarJs(controlAddIn, {
    isWidget: widget,
    onOptionsUpdated: function (options) {
      syncOptionsBC(options);
      return true;
    },
    onSearchOptionsUpdated: function (options) {
      syncSearchOptionsBC(options);
      return true;
    },
    onFetchEvents: function () {
      if (!widget) {
        return true;
      }
      getEvents();
    },
    onEventAdded: function (event) {
      syncEvent2BC(event);
      return true;
    },
    onEventUpdated: function (event) {
      syncEvent2BC(event);
      return true;
    },
    onEventRemoved: function (event) {
      removeEventFromBC(event);
      return true;
    },
    useLocalStorageForEvents: false,
  });

  bccalendar.turnOnFullScreen();
  newOptions["isWidget"] = widget;
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

function onEventUpdate(event) {
  syncEvent2BC(event);
}

// get the event JsonArray from AL
async function getEvents() {
  let call = getALEventHandler("OnFetchEvents", false);
  let res = await call();
  if (res === null) {
    res = [];
  }
  bccalendar.setEventsFromJson(JSON.stringify(res));
}

// sync the event details with BC.
async function syncOptionsBC(event) {
  let call = getALEventHandler("OnSyncOptionsBC", false);
  let res = await call(event);
  console.log(JSON.stringify(res));
  if (res === null) {
    res = [];
  }
  return res;
}

// sync the event details with BC.
async function syncSearchOptionsBC(event) {
  let call = getALEventHandler("OnSyncSearchOptionsBC", false);
  let res = await call(event);
  console.log(JSON.stringify(res));
  if (res === null) {
    res = [];
  }
  return res;
}

// sync the event details with BC.
async function syncEvent2BC(event) {
  let call = getALEventHandler("OnSyncEvent2BC", false);
  let res = await call(event);
  console.log(JSON.stringify(res));
  if (res === null) {
    res = [];
  }
  return res;
}

// remove the event details from BC.
async function removeEventFromBC(event) {
  let call = getALEventHandler("RemoveEventFromBC", false);
  let res = await call(event);
  console.log(JSON.stringify(res));
  if (res === null) {
    res = [];
  }
  return res;
}

// get return value from AL trigger or proc
function getALEventHandler(eventName, skipIfBusy) {
  return (...args) =>
    new Promise((resolve) => {
      let res;

      let eRes = `${eventName}Result`;
      window[eRes] = (alRes) => {
        res = alRes;
        delete window[eRes];
      };

      Microsoft.Dynamics.NAV.InvokeExtensibilityMethod(
        eventName,
        args,
        skipIfBusy,
        () => resolve(res)
      );
    });
}
