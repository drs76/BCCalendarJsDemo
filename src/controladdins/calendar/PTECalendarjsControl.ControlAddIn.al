controladdin PTECalendarjsControl
{

    Scripts = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js',
                'src/controladdins/calendar/calendarjs/dist/calendar.min.js',
                'src/controladdins/calendar/scripts/ptecalendarjs.js';

    StartupScript = 'src/controladdins/calendar/scripts/ptecalendarjs_start.js';

    StyleSheets = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css',
                    'src/controladdins/calendar/calendarjs/dist/calendar.js.min.css';

    HorizontalShrink = true;
    HorizontalStretch = true;
    VerticalStretch = true;


    event ControlReady();
    event OnFetchEvents();
    event OnSyncOptionsBC(options: JsonObject);
    event OnSyncEvent2BC(entry: JsonObject);
    event OnRemoveEventFromBC(entry: JsonObject);

    procedure InitCalendar(options: JsonObject)
    procedure SetOptions(options: JsonObject)
    procedure SetViewOptions(viewOptions: JsonObject)
    procedure SetSearchOptions(searchOptions: JsonObject)

    procedure OnFetchEventsResult(events: JsonArray)
    procedure OnSyncOptionsBCResult(result: JsonObject)
    procedure OnSyncEvent2BCResult(result: JsonObject)
    procedure OnRemoveEventFromBCResult(result: JsonObject)
}
