controladdin PTECalendarjsControl
{

    Scripts = 'src/controladdins/calendar/calendarjs/dist/calendar.min.js',
                'src/controladdins/calendar/scripts/ptecalendarjs.js';

    StartupScript = 'src/controladdins/calendar/scripts/ptecalendarjs_start.js';

    StyleSheets = 'src/controladdins/calendar/calendarjs/dist/calendar.js.min.css';


    HorizontalShrink = true;
    HorizontalStretch = true;
    VerticalStretch = true;
    VerticalShrink = false;
    RequestedHeight = 680;

    event ControlReady();
    event OnFetchEvents();
    event OnSyncOptionsBC(options: JsonObject);
    event OnSyncSearchOptionsBC(options: JsonObject);
    event OnSyncEvent2BC(entry: JsonObject);
    event OnRemoveEventFromBC(entry: JsonObject);

    procedure InitCalendar(options: JsonObject; widget: Boolean)
    procedure SetOptions(options: JsonObject)
    procedure SetViewOptions(viewOptions: JsonObject)
    procedure SetSearchOptions(searchOptions: JsonObject)
    procedure SetEvents(events: JsonArray);

    procedure OnFetchEventsResult(events: JsonArray)
    procedure OnSyncOptionsBCResult(result: JsonObject)
    procedure OnSyncSearchOptionsBCResult(result: JsonObject)
    procedure OnSyncEvent2BCResult(result: JsonObject)
    procedure OnRemoveEventFromBCResult(result: JsonObject)
}
