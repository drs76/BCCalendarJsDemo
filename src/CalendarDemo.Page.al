/// <summary>
/// Page PTECalendarDemo (ID 50101).
/// </summary>
page 50203 PTECalendarDemo
{
    Caption = 'Calendar Demo';
    AdditionalSearchTerms = 'calendar';
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            usercontrol(PTECalendar; PTECalendarjsControl)
            {
                ApplicationArea = All;

                // Control addin is ready, we can use the calendar now.
                trigger ControlReady()
                begin
                    SetupCalendar();
                end;

                /// <summary>
                /// GetEvents.
                /// Called when event data is required, changing of date range/view.
                /// The fetchInfo contains the start and end dates for the calendar range being displayed.
                /// </summary>
                /// <param name="fetchInfo">JsonObject.</param>
                trigger GetEvents(fetchInfo: JsonObject)
                begin
                    Clear(EventMgt);
                    BuildEvents(fetchInfo);
                    CurrPage.PTECalendar.GetEventsResult(EventMgt.GetEvents());
                end;

                // ASYNC - Fires from OnDateClicked and OnEventClicked on JSCalendar
                // Opens page to allow edit of event, or open any page you want.
                trigger OpenCalendarEntry(entry: Text; adding: Boolean)
                var
                    Entry2: JsonObject;
                begin
                    Entry2.ReadFrom(entry);
                    OpenCalendarEntry(Entry2, adding, false);
                end;

                // ASYNC - Fires when an existing entry on the JSCalendar is dragged or resized.
                trigger UpdateBCWithCalendarEntry(entry: Text)
                var
                    JResult: JsonObject;
                    NewEntry: JsonObject;
                    JToken: JsonToken;
                    UpdatedOK: Boolean;
                    ResultLbl: Label 'success';
                begin
                    // udpate BC with changes to the event performed on calendar, i.e. drag drop or resize..
                    // set the UpdatedOK flag accordingly.
                    // We are just replacing the entry in the collection with the one from the calendar as it has the new dates.
                    NewEntry.ReadFrom(entry);
                    UpdatedOK := NewEntry.Get(IdLbl, JToken);
                    if UpdatedOK then begin
                        EventMgt.SetCurrentEvent(NewEntry);
                        EventMgt.AddEventToCollection(NewEntry);
                    end;
                    //send the update status back to calendar, true to keep change, false to revert.
                    JResult.Add(ResultLbl, UpdatedOK);
                    CurrPage.PTECalendar.UpdateBCWithCalendarEntryResult(JResult);
                end;

                // ASYNC -  Fires when an external event is dragged onto the JSCalendar
                trigger HandleExternalDraggedEvent(entry: Text)
                var
                    JEvent2: JsonObject;
                begin
                    JEvent2.ReadFrom(entry);
                    AddDraggedEvent(JEvent2);
                end;
            }
        }
    }

    /// <summary>
    /// BuildResources.
    /// </summary>
    /// <param name="fetchInfo">JsonObject.</param>
    local procedure BuildEvents(fetchInfo: JsonObject)
    var
        FirstDate: Date;
        LastDate: Date;
    begin
        Clear(EventMgt); // clear events
        FullCalendarHelper.GetCalendarDateRange(fetchInfo, FirstDate, LastDate);
    end;

    /// <summary>
    /// BuildExternalEvents.
    /// These are the draggable events.
    /// </summary>
    local procedure BuildExternalEvents()
    begin
    end;

    /// <summary>
    /// OpenCalendarEntry.
    /// This is called async so we must always call CurrPage.FullCalendar.HandleExternalDraggedEventResult
    /// as the calendar is awaiting a response, even if nothing is done.
    /// </summary>
    /// <param name="Entry">JsonObject.</param>
    /// <param name="Adding">Boolean.</param>
    /// <param name="Dragged">Boolean.</param>
    /// <returns>Return variable ReturnValue of type Boolean.</returns>
    local procedure OpenCalendarEntry(Entry: JsonObject; Adding: Boolean; Dragged: Boolean)
    var
        FullCalendarEvent: Page PTEFullCalendarEvent;
        JsonResult: JsonObject;
    begin
        FullCalendarEvent.InitPage(Entry, adding);
        FullCalendarEvent.SetDragged(Dragged);
        // You can change which page you want to open here, or dont event open a page.
        if FullCalendarEvent.RunModal() = Action::OK then;
        FullCalendarEvent.GetResult(JsonResult);
        SendOpenCalendarResult(JsonResult, Dragged);
    end;

    /// <summary>
    /// SendOpenCalendarResult.
    /// </summary>
    /// <param name="JsonResult">JsonObject.</param>
    /// <param name="Dragged">Boolean.</param>
    local procedure SendOpenCalendarResult(JsonResult: JsonObject; Dragged: Boolean)
    var
        SalesHeader: Record "Sales Header";
        FullCalendarEvent: Page PTEFullCalendarEvent;
        JToken: JsonToken;
        UpdateOk: Boolean;
        UpdateLbl: Label 'update';
    begin
        UpdateOk := FullCalendarEvent.GetValueSafely(UpdateLbl, JsonResult, UpdateOk);
        if UpdateOk then begin
            // Check we can get the BC record for the event.
            JsonResult.Get(IdLbl, JToken);
            UpdateOk := SalesHeader.Get(SalesHeader."Document Type"::Order, JToken.AsValue().AsText());
        end;

        if not UpdateOK then begin
            if JsonResult.Contains(UpdateLbl) then
                JsonResult.Replace(UpdateLbl, false)
            else
                JsonResult.Add(UpdateLbl, false);
        end else
            Message(JsonResult.AsToken().AsValue().AsText());
        // Update Sales Header

        // If dragged content add new event to the EventMgt Collection.
        if Dragged then
            //TODO: Soft bug Remove from external events.
            CurrPage.PTECalendar.HandleExternalDraggedEventResult(JsonResult) // return empty for async call.
        else
            CurrPage.PTECalendar.OpenCalendarEntryResult(JsonResult) //send the changed data back to calendar js
    end;

    /// <summary>
    /// AddDraggedEvent.
    /// </summary>
    /// <param name="JEvent">JsonObject.</param>
    local procedure AddDraggedEvent(JEvent: JsonObject)
    var
        SalesHeader: Record "Sales Header";
        JResult: JsonObject;
        JToken: JsonToken;
        OrderNo: Text;
    begin
        JEvent.Get(IdLbl, JToken);
        OrderNo := JToken.AsValue().AsText();
        if not SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo) then begin
            CurrPage.PTECalendar.HandleExternalDraggedEventResult(JResult); // return empty for async call.
            exit;
        end;

        OpenCalendarEntry(JEvent, false, true);
    end;

    /// <summary>
    /// SetupCalendar.
    /// Create the CalendarSetupMgt codeunit options which will be passed to the calendar as a JsonObject.
    /// </summary>
    local procedure SetupCalendar()
    var
        FullCalHelper: Codeunit PTEFullCalendarHelper;
        BusinessHours: JsonObject;
        DaysOfWeekTxt: Label '[1,2,3,4,5]';// Mon-Fri
    begin
        CalendarSetupMgt.InitSetup();
        CalendarSetupMgt.SetEditable(true);
        CalendarSetupMgt.SetAllowedToAddEvents(false); // set to add new events, or false to only allow draggable and loaded events.
        CalendarSetupMgt.SetEnable2GridView(false);
        CalendarSetupMgt.SetAllDaySlot(true); // show all day slot on time views.,
        CalendarSetupMgt.SetSlotDurationMinutes(15);

        BusinessHours := FullCalHelper.CreateConstraint(100000T, 190000T, DaysOfWeekTxt);

        BuildExternalEvents(); // build the draggable objects, as they are required from start.

        CurrPage.PTECalendar.InitCalendar(CalendarSetupMgt.GetCalendarSetup(), true); //setup & show calendar with initial view draggable is enabled.
        CurrPage.PTECalendar.SetInitialDate(Today()); // move to a specific date on start
    end;

    var
        CalendarSetupMgt: Codeunit PTEFullCalendarSetupMgt;
        EventMgt: Codeunit PTEFullCalendarEventMgt;
        ExternalEventMgt: Codeunit PTEFullCalendarEventMgt;
        FullCalendarHelper: Codeunit PTEFullCalendarHelper;
        SourceType: Option Resource,Events,External,"Resource+Events";
        EmptyTxt: Label '';
        IdLbl: Label 'id';
}
