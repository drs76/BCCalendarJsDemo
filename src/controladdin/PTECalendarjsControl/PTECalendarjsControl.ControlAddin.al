controladdin PTECalendarjsControl
{

    Scripts = 'src/controladdin/calendar/calendarjs/dist/calendar.min.js',
                'src/controladdin/calendar/scripts/ptecalendarjs.js';

    StartupScript = 'src/controladdin/calendar/scripts/ptecalendarjs_start.js';

    StyleSheets = 'src/controladdin/calendar/calendarjs/dist/calendar.js.min.css',
                    'src/controladdin/calendar/scripts/ptecalendar.css';


    HorizontalShrink = true;
    HorizontalStretch = true;
    VerticalStretch = true;
    VerticalShrink = false;
    RequestedHeight = 800;

    event ControlReady();
    event OnFetchEvents();
    event OnSyncOptionsBC(options: JsonObject);
    event OnSyncSearchOptionsBC(options: JsonObject);
    event OnModEvent2BC(entry: JsonObject);
    event OnRemoveEventFromBC(entry: JsonObject);

    procedure InitCalendar(options: JsonObject; widget: Boolean)
    procedure SetOptions(options: JsonObject)
    procedure SetViewOptions(viewOptions: JsonObject)
    procedure SetSearchOptions(searchOptions: JsonObject)
    procedure SetEvents(events: JsonArray);

    procedure OnFetchEventsResult(events: JsonArray)
    procedure OnSyncOptionsBCResult(result: JsonObject)
    procedure OnSyncSearchOptionsBCResult(result: JsonObject)
    procedure OnModEvent2BCResult(result: JsonObject)
    procedure OnRemoveEventFromBCResult(result: JsonObject)
}
