/// <summary>
/// ControlAddIn PTEFullCalendarControl.
/// </summary>
controladdin PTEFullCalendarControl
{

    Scripts = 'src/controladdins/calendar/lib/main.min.js',
                'src/controladdins/calendar/scripts/fullCalendar.js';

    StartupScript = 'src/controladdins/calendar/scripts/fullCalendarStart.js';

    StyleSheets = 'https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css',
                    'https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css',
                    'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.13.1/css/all.css',
                    'src/controladdins/calendar/lib/main.min.css',
                    'src/controladdins/calendar/scripts/styles.css';
    VerticalShrink = true;
    HorizontalShrink = true;
    VerticalStretch = true;
    HorizontalStretch = true;


    /// <summary>
    /// ControlReady.
    /// </summary>
    event ControlReady();

    /// <summary>
    /// OpenCalendarEntry.
    /// </summary>
    /// <param name="entry">Text.</param>
    /// <param name="adding">Boolean.</param>
    event OpenCalendarEntry(entry: Text; adding: Boolean);

    /// <summary>
    /// UpdateBCWithCalendarEntry.
    /// </summary>
    /// <param name="entry">Text.</param>
    event UpdateBCWithCalendarEntry(entry: Text);

    /// <summary>
    /// GetEvents.
    /// </summary>
    /// <param name="fetchInfo">JsonObject.</param>
    event GetEvents(fetchInfo: JsonObject);

    /// <summary>
    /// GetResources.
    /// </summary>
    /// <param name="fetchInfo">JsonObject.</param>
    event GetResources(fetchInfo: JsonObject);

    /// <summary>
    /// HandleExternalDraggedEvent.
    /// </summary>
    /// <param name="entry">JsonObject.</param>
    event HandleExternalDraggedEvent(entry: Text);

    /// <summary>
    /// GetOpenCalendarEntryResult.
    /// Return result from open calendar entry page.
    /// </summary>
    /// <param name="Result">JsonObject.</param>    
    procedure OpenCalendarEntryResult(Result: JsonObject);

    /// <summary>
    /// UpdateBCWithCalendarEntryResult.
    /// </summary>
    /// <param name="Result">JsonObject.</param>
    procedure UpdateBCWithCalendarEntryResult(Result: JsonObject);

    /// <summary>
    /// GetEventsResult.
    /// </summary>
    /// <param name="Result">JsonArray.</param>
    procedure GetEventsResult(Result: JsonArray);

    /// <summary>
    /// GetResourcesResult.
    /// </summary>
    /// <param name="Result">JsonArray.</param>
    procedure GetResourcesResult(Result: JsonArray);

    /// <summary>
    /// InitCalendar.
    /// </summary>
    /// <param name="settings">JsonObject.</param>
    /// <param name="enableDraggable">Boolean.</param>
    procedure InitCalendar(settings: JsonObject; enableDraggable: Boolean);

    /// <summary>
    /// SetInitialDate.
    /// </summary>
    /// <param name="InitialDate">Date.</param>
    procedure SetInitialDate(InitialDate: Date);

    /// <summary>
    /// SetAllowedToAddEvents.
    /// </summary>
    /// <param name="Setting">Boolean.</param>
    procedure SetAllowedToAddEvents(Setting: Boolean)

    /// <summary>
    /// HandleExternalDraggedEventResult.
    /// </summary>
    /// <param name="Result">JsonObject.</param>
    procedure HandleExternalDraggedEventResult(Result: JsonObject);

}
