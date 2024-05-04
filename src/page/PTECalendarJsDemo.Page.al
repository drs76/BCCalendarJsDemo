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
                trigger OnFetchEvents()
                var
                    Events: JsonArray;
                begin
                    Events := BuildEvents();
                    CurrPage.PTECalendar.OnFetchEventsResult(Events);
                end;

                // ASYNC - Fires when the calendar options are updated.
                trigger OnSyncOptionsBC(options: JsonObject)
                begin
                    HandleCalendarUpdate(options, CalendarUpdate::OptionsUpdate);
                end;

                // ASYNC - Fires when an existing entry on the Calendar is updated.
                trigger OnSyncEvent2BC(entry: JsonObject)
                begin
                    HandleCalendarUpdate(entry, CalendarUpdate::EventUpdate);
                end;

                // ASYNC - Fires when an existing entry on the Calendar is removed.
                trigger OnRemoveEventFromBC(entry: JsonObject)
                begin
                    HandleCalendarUpdate(entry, CalendarUpdate::EventRemove);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        Customer: Record Customer;
    begin
        Customer.FindFirst();
        InitCalendarSource(Database::Customer, Customer.SystemId);
    end;

    var
        CalendarJSSetup: Record PTECalendarJsSetup;
        SourceRef: RecordRef;
        KeyData: array[5] of Code[50];
        CalendarUpdate: Option OptionsUpdate,EventUpdate,EventRemove;
        IdLbl: Label 'id';


    internal procedure InitCalendarSource(TableNo: Integer; RecSysId: Guid)
    var
        KeyRef: KeyRef;
        i: Integer;
    begin
        SourceRef.Open(TableNo);
        SourceRef.GetBySystemId(RecSysId);

        KeyRef := SourceRef.KeyIndex(1);//PK
        for i := 1 to KeyRef.FieldCount() do
            KeyData[i] := Format(KeyRef.FieldIndex(i));
    end;


    local procedure BuildEvents(): JsonArray
    var
        CalendarJsHelper: Codeunit PTECalendarJsHelper;
    begin
        exit(CalendarJsHelper.BuildEvents(SourceRef.Number(), KeyData));
    end;

    local procedure HandleCalendarUpdate(CalObject: JsonObject; UpdateType: Option OptionsUpdate,EventUpdate,EventRemove)
    var
        JResult: JsonObject;
        JToken: JsonToken;
        id: Guid;
        UpdatedOK: Boolean;
        ResultLbl: Label 'success';
    begin
        case UpdateType of
            UpdateType::EventUpdate, UpdateType::EventRemove:
                begin
                    UpdatedOK := CalObject.Get(IdLbl, JToken);
                    if UpdatedOK then
                        UpdatedOK := Evaluate(id, JToken.AsValue().AsText());

                    if UpdatedOK then
                        if UpdateType = UpdateType::EventUpdate then
                            SyncEvent(id, CalObject)
                        else
                            RemoveEvent(id);
                    //send the update status back to calendar;
                    JResult.Add(ResultLbl, UpdatedOK);
                    if UpdateType = UpdateType::EventUpdate then
                        CurrPage.PTECalendar.OnSyncEvent2BCResult(JResult)
                    else
                        CurrPage.PTECalendar.OnRemoveEventFromBCResult(JResult);
                end;
            UpdateType::OptionsUpdate:
                begin
                    SyncOptions(CalObject);
                    JResult.Add(ResultLbl, UpdatedOK);
                    CurrPage.PTECalendar.OnSyncOptionsBCResult(JResult);
                end;
        end;
    end;

    local procedure SyncOptions(Options: JsonObject)
    var
        CalendarJsHelper: Codeunit PTECalendarJsJsonHelper;
        RecRef: RecordRef;
    begin
        RecRef.GetTable(CalendarJSSetup);
        CalendarJsHelper.JsonToRecord(RecRef, Options);
        RecRef.SetTable(CalendarJSSetup);
        CalendarJSSetup.Modify(true);
    end;

    local procedure SyncEvent(Id: Guid; CalEvent: JsonObject)
    var
        CalendarJsEvent: Record PTECalendarJsEvent;
        CalendarJsHelper: Codeunit PTECalendarJsJsonHelper;
        RecRef: RecordRef;
        NewEvent: Boolean;
    begin
        CalendarJsEvent.Reset();
        CalendarJsEvent.SetRange(TableNo, SourceRef.Number());
        CalendarJsEvent.SetRange(Id, Id);
        NewEvent := not CalendarJsEvent.FindFirst();
        if NewEvent then begin
            CalendarJsEvent.Init();
            CalendarJsEvent.SetKeyData(KeyData);
            CalendarJsEvent.BCRecordSystemId := SourceRef.Field(SourceRef.SystemIdNo).Value;
            CalendarJsEvent.TableNo := SourceRef.Number();
        end;

        RecRef.GetTable(CalendarJsEvent);
        CalendarJsHelper.JsonToRecord(RecRef, CalEvent);
        RecRef.SetTable(CalendarJsEvent);
        if NewEvent then
            CalendarJsEvent.Insert(true)
        else
            CalendarJsEvent.Modify(true);
    end;

    local procedure RemoveEvent(Id: Guid)
    var
        CalendarJsEvent: Record PTECalendarJsEvent;
    begin
        CalendarJsEvent.Reset();
        CalendarJsEvent.SetRange(TableNo, SourceRef.Number());
        CalendarJsEvent.SetRange(Id, Id);
        if CalendarJsEvent.FindFirst() then
            CalendarJsEvent.Delete(true);
    end;

    local procedure SetupCalendar()
    var
        CalendarJsHelper: Codeunit PTECalendarJsHelper;
        CurrCalCode: Code[20];
    begin
        CurrPage.PTECalendar.InitCalendar(CalendarJsHelper.GetCalendarSettings(CurrCalCode)); //setup & show calendar with initial view
        CalendarJSSetup.Get(CurrCalCode);
    end;

}
