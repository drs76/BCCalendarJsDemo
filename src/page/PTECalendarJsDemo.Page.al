page 50203 PTECalendarJsDemo
{
    Caption = 'CalendarJs Demo';
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

                // ASYNC - Fires to get events for calendar
                trigger GetEvents()
                begin
                    Clear(EventMgt);
                    BuildEvents();
                    CurrPage.PTECalendar.GetEventsResult(EventMgt.GetEvents());
                end;

                // ASYNC - Fires when an existing entry on the Calendar is updated.
                trigger SyncEvent2BC(entry: JsonObject)
                var
                    JResult: JsonObject;
                    JToken: JsonToken;
                    UpdatedOK: Boolean;
                    ResultLbl: Label 'success';
                begin
                    UpdatedOK := entry.Get(IdLbl, JToken);
                    //send the update status back to calendar, true to keep change, false to revert.
                    JResult.Add(ResultLbl, UpdatedOK);
                end;

                trigger RemoveEventFromBC(entry: JsonObject)
                var
                    JToken: JsonToken;
                    JResult: JsonObject;
                    id: Guid;
                    UpdatedOK: Boolean;
                    ResultLbl: Label 'success';
                begin
                    UpdatedOK := entry.Get(IdLbl, JToken);
                    if UpdatedOK then
                        UpdatedOK := Evaluate(id, JToken.AsValue().AsText());

                    //send the update status back to calendar, true to keep change, false to revert.
                    JResult.Add(ResultLbl, UpdatedOK);
                end;
            }
        }
    }

    local procedure BuildEvents()
    var
        FirstDate: Date;
        LastDate: Date;
    begin
        Clear(EventMgt); // clear events
        //FullCalendarHelper.GetCalendarDateRange(fetchInfo, FirstDate, LastDate);
    end;

    local procedure BuildExternalEvents()
    begin
    end;

    local procedure SetupCalendar()
    var
        CalendarJsHelper: Codeunit PTECalendarJsHelper;
    begin
        BuildExternalEvents(); // build the draggable objects, as they are required from start.

        CurrPage.PTECalendar.InitCalendar(CalendarJsHelper.GetCalendarSettings()); //setup & show calendar with initial view draggable is enabled.
        //CurrPage.PTECalendar.SetInitialDate(Today()); // move to a specific date on start
    end;

    var
        EventMgt: Codeunit PTEFullCalendarEventMgt;
        IdLbl: Label 'id';
}
