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

                /// <summary>
                /// GetResources.
                /// Called when resource data is required, changing of date range/view.
                /// The fetchInfo contains the start and end dates for the calendar range being displayed.
                /// </summary>
                /// <param name="fetchInfo">JsonObject.</param>
                trigger GetResources(fetchInfo: JsonObject)
                begin
                    Clear(ResourceMgt);
                    BuildResources();
                    CurrPage.PTECalendar.GetResourcesResult(ResourceMgt.GetResources());
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
                        UpdateSalesHeaderWithDelivery(NewEntry);
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
    /// Build collection of Resources for Calendar
    /// </summary>
    local procedure BuildResources()
    var
        ShippingAgent: Record "Shipping Agent";
    begin
        Clear(ResourceMgt); //Clear resources
        if not ShippingAgent.FindSet() then
            exit;

        repeat
            CreateResource(ShippingAgent);
        until ShippingAgent.Next() = 0;
    end;

    /// <summary>
    /// BuildResources.
    /// </summary>
    /// <param name="fetchInfo">JsonObject.</param>
    local procedure BuildEvents(fetchInfo: JsonObject)
    var
        SalesHeader: Record "Sales Header";
        FirstDate: Date;
        LastDate: Date;
    begin
        Clear(EventMgt); // clear events
        FullCalendarHelper.GetCalendarDateRange(fetchInfo, FirstDate, LastDate);

        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("Shipping Agent Code", '<>%1', '');
        //TODO: Add back in
        SalesHeader.SetRange("Shipment Date", FirstDate, LastDate);
        if not SalesHeader.FindSet() then
            exit;

        repeat
            CreateEvent(SalesHeader, false, SourceType::Events);
        until SalesHeader.Next() = 0;
    end;

    /// <summary>
    /// BuildExternalEvents.
    /// These are the draggable events.
    /// </summary>
    local procedure BuildExternalEvents()
    var
        SalesHeader: Record "Sales Header";
    begin
        Clear(ExternalEventMgt); // clear external
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Shipping Agent Code", '');
        if not SalesHeader.FindSet() then
            exit;

        repeat
            CreateEvent(SalesHeader, false, SourceType::External);
        until SalesHeader.Next() = 0;
    end;

    /// <summary>
    /// CreateResource.
    /// </summary>
    /// <param name="ShippingAgent">Record "Shipping Agent".</param>
    local procedure CreateResource(ShippingAgent: Record "Shipping Agent")
    var
        BusinessHours: JsonObject;
    begin
        ResourceMgt.CreateResource(ShippingAgent.Code);
        ResourceMgt.SetTitle(ShippingAgent.Name);
        ResourceMgt.SetEventBackgroundColor(ShippingAgent.PTECalendarBackground);
        ResourceMgt.SetBackgroundColour(ShippingAgent.PTECalendarBackground);

        //Resource Event constraint is the allowed hours an event can be booked for this resource.
        BusinessHours := FullCalendarHelper.CreateConstraint(ShippingAgent.PTEOpeningTime, ShippingAgent.PTEClosingTime, ShippingAgent.PTEDays);
        ResourceMgt.SetEventContstraint(BusinessHours);
        // add new resource to the collection
        ResourceMgt.AddResourceToCollection();
    end;

    /// <summary>
    /// CreateEvent
    /// Create a calendar event and add it to the event collection.
    /// </summary>
    /// <param name="SalesHeader">Record "Sales Header".</param>
    /// <param name="Dragged">Boolean.</param>
    /// <param name="Type">Integer.</param>
    local procedure CreateEvent(SalesHeader: Record "Sales Header"; Dragged: Boolean; Type: Integer)
    var
        CalendarHelper: Codeunit PTEFullCalendarHelper;
    begin
        EventMgt.CreateEvent(SalesHeader."No.");
        EventMgt.SetTitle(SalesHeader."No.");
        EventMgt.SetTooltipText(CalendarHelper.BuildAddressString(SalesHeader));
        if Format(SalesHeader."Sell-to Post Code").IndexOf(' ') = 0 then
            EventMgt.SetPostcode(SalesHeader."Sell-to Post Code")
        else
            EventMgt.SetPostcode(Format(SalesHeader."Sell-to Post Code").Substring(1, Format(SalesHeader."Sell-to Post Code").IndexOf(' ') - 1));
        if Type = SourceType::Events then
            EventMgt.SetResourceId(SalesHeader."Shipping Agent Code");

        if SalesHeader."Shipment Date" <> 0D then begin
            EventMgt.SetAllDay(SalesHeader.PTEDeliverySlotAllDay);
            EventMgt.SetStartDateTime(CalendarHelper.GetEventDate(SalesHeader."Shipment Date", SalesHeader.PTEDeliverySlotStart));
            EventMgt.SetEndDateTime(CalendarHelper.GetEventDate(SalesHeader."Shipment Date", SalesHeader.PTEDeliverySlotEnd));
        end;

        // to disable changing of events set to false.
        EventMgt.SetEditable(true);
        EventMgt.SetDurationEditable(true);
        EventMgt.SetStartEditable(true);
        EventMgt.SetResourceEditable(true);

        if (Type = SourceType::Events) and ((SalesHeader."Shipping Agent Code" <> EmptyTxt) or Dragged) then begin
            EventMgt.AddEventToCollection(); // Add calendar event to the event collection.
            exit;
        end;

        if Type <> SourceType::External then
            exit;

        if SalesHeader."Shipping Agent Code" <> EmptyTxt then
            exit;

        // Add external event to the external event collection
        ExternalEventMgt.SetCurrentEvent(EventMgt.GetCurrentEvent());
        //ExternalEventMgt.SetResourceId('');
        ExternalEventMgt.AddEventToCollection();
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
            // Update Sales Header
            UpdateSalesHeaderWithDelivery(JsonResult, SalesHeader);

        // If dragged content add new event to the EventMgt Collection.
        if Dragged then begin
            if UpdateOk then
                CreateEvent(SalesHeader, Dragged, SourceType::Events);

            //TODO: Soft bug Remove from external events.
            CurrPage.PTECalendar.HandleExternalDraggedEventResult(JsonResult); // return empty for async call.
        end else
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
        DragEventTitleLbl: Label 'Sales Orders';
        EventTextColourLbl: Label '#000000', Comment = 'Undefined';
    begin
        CalendarSetupMgt.InitSetup();
        CalendarSetupMgt.SetEditable(true);
        CalendarSetupMgt.SetAllowedToAddEvents(false); // set to add new events, or false to only allow draggable and loaded events.
        CalendarSetupMgt.SetEnable2GridView(false);
        CalendarSetupMgt.SetAllDaySlot(true); // show all day slot on time views.,
        CalendarSetupMgt.SetExternalHeader(DragEventTitleLbl); // header for draggable events.
        CalendarSetupMgt.SetResourceHeader(DragEventTitleLbl); // header for resources on calendar.
        CalendarSetupMgt.SetEventsTextColor(EventTextColourLbl); // text colour for events
        CalendarSetupMgt.SetDefaultView(Format(Enum::PTEFullCalendarView::ResourceTimelineDay)); //intitial view shown.
        CalendarSetupMgt.SetSlotDurationMinutes(15);
        CalendarSetupMgt.SetDragColorCheckByResourceId(false); // use the resource id in the near / far checks.
        CalendarSetupMgt.SetDragColorSettings(CreateGreenAmberRed()); // green amber red postcodes for near / far checks.

        BusinessHours := FullCalHelper.CreateConstraint(100000T, 190000T, DaysOfWeekTxt);
        CalendarSetupMgt.SetBusinessHours(BusinessHours); // default business hours for calendar, can be overriden using resource businesshours.

        BuildExternalEvents(); // build the draggable objects, as they are required from start.
        CalendarSetupMgt.SetExternalEvents(ExternalEventMgt.GetEvents()); // add draggable object collection to the setup.

        CurrPage.PTECalendar.InitCalendar(CalendarSetupMgt.GetCalendarSetup(), true); //setup & show calendar with initial view draggable is enabled.
        CurrPage.PTECalendar.SetInitialDate(Today()); // move to a specific date on start
    end;

    /// <summary>
    /// CreateGreenAmberRed.
    /// </summary>
    local procedure CreateGreenAmberRed(): JsonArray
    var
        GreenAmberRed: Codeunit PTEFullCalendarGreenAmberRed;
    begin
        GreenAmberRed.CreateGAR('DHL');
        GreenAmberRed.SetPostCode1('CV6');
        GreenAmberRed.SetPostCode2('CV6');
        GreenAmberRed.SetColor('Green');
        // GreenAmberRed.AddGARToCollection();
        // GreenAmberRed.CreateGAR('FEDEX');
        // GreenAmberRed.SetPostCode1('CV6');
        // GreenAmberRed.SetPostCode2('CV6');
        // GreenAmberRed.SetColor('Green');
        GreenAmberRed.AddGARToCollection();
        exit(GreenAmberRed.GetRedAmberGreens());
    end;

    /// <summary>
    /// UpdateSalesHeaderWithDelivery.
    /// </summary>
    /// <param name="NewEntry">JsonObject.</param>
    /// <returns>Return variable ReturnValue of type Boolean.</returns>
    local procedure UpdateSalesHeaderWithDelivery(NewEntry: JsonObject) ReturnValue: Boolean
    var
        SalesHeader: Record "Sales Header";
        JToken: JsonToken;
    begin
        NewEntry.Get(IdLbl, JToken);
        if not SalesHeader.Get(SalesHeader."Document Type"::Order, JToken.AsValue().AsText()) then
            exit;

        UpdateSalesHeaderWithDelivery(NewEntry, SalesHeader);
        ReturnValue := true;
    end;

    /// <summary>
    /// UpdateSalesHeaderWithDelivery.
    /// </summary>
    /// <param name="EventEntry">JsonObject.</param>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    local procedure UpdateSalesHeaderWithDelivery(EventEntry: JsonObject; var SalesHeader: Record "Sales Header")
    var
        EventPage: Page PTEFullCalendarEvent;
        JToken: JsonToken;
        DateTValue: DateTime;
        TimeValue: Time;
        AllDay: Boolean;
        StartLbl: Label 'start';
        EndLbl: Label 'end';
        AllDayLbl: Label 'allDay';
    begin
        EventEntry.Get(AllDayLbl, JToken);
        AllDay := JToken.AsValue().AsBoolean();
        SalesHeader.SetHideValidationDialog(true);
        SalesHeader.PTEDeliverySlotAllDay := AllDay;
        if not AllDay then begin
            EventEntry.Get(StartLbL, JToken);
            DateTValue := EventPage.GetValueSafely(StartLbl, EventEntry, DateTValue);
            TimeValue := DT2Time(DateTValue);
            SalesHeader.Validate("Shipment Date", DT2Date(DateTValue));
            SalesHeader.Validate(PTEDeliverySlotStart, TimeValue);

            EventEntry.Get(StartLbL, JToken);
            DateTValue := EventPage.GetValueSafely(EndLbl, EventEntry, DateTValue);
            TimeValue := DT2Time(DateTValue);
            SalesHeader.Validate(PTEDeliverySlotEnd, TimeValue);
        end;
        if EventEntry.Get(ResourceIdLbl, JToken) then
            SalesHeader.Validate("Shipping Agent Code", CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(SalesHeader."Shipping Agent Code")));
        SalesHeader.Modify(true);
        Commit();
    end;

    var
        CalendarSetupMgt: Codeunit PTEFullCalendarSetupMgt;
        ResourceMgt: Codeunit PTEFullCalendarResourceMgt;
        EventMgt: Codeunit PTEFullCalendarEventMgt;
        ExternalEventMgt: Codeunit PTEFullCalendarEventMgt;
        FullCalendarHelper: Codeunit PTEFullCalendarHelper;
        SourceType: Option Resource,Events,External,"Resource+Events";
        EmptyTxt: Label '';
        IdLbl: Label 'id';
        ResourceIdLbl: Label 'resourceId';
}
