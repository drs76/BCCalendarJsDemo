codeunit 50208 PTECalendarPageMgt
{
    var
        CalendarJSSetup: Record PTECalendarJsSetup;
        SourceRef: RecordRef;
        KeyData: array[5] of Code[50];
        IdLbl: Label 'id';


    internal procedure SetCalendarSetup(var InCalendarJSSetup: Record PTECalendarJsSetup; InSourceRef: RecordRef; InKeyData: array[5] of Code[50])
    var
        i: Integer;
    begin
        if SourceRef.Number() > 0 then
            SourceRef.Close();

        SourceRef.Open(InSourceRef.Number());
        SourceRef.Copy(InSourceRef);
        CalendarJSSetup.Copy(InCalendarJSSetup);
        for i := 1 to 5 do
            KeyData[i] := InKeyData[i];
    end;

    internal procedure BuildEvents(): JsonArray
    var
        CalendarJsHelper: Codeunit PTECalendarJsHelper;
    begin
        exit(CalendarJsHelper.BuildEvents(SourceRef.Number(), KeyData));
    end;

    internal procedure HandleCalendarUpdate(CalObject: JsonObject; UpdateType: Option OptionsUpdate,SearchOptionsUpdate,EventUpdate,EventRemove) ReturnValue: JsonObject
    var
        JToken: JsonToken;
        id: Guid;
        GotId: Boolean;
        ResultLbl: Label 'success';
    begin
        if UpdateType in [UpdateType::EventUpdate, UpdateType::EventRemove] then begin
            GotId := CalObject.Get(IdLbl, JToken);
            if GotId then
                GotId := Evaluate(id, JToken.AsValue().AsText());
            if not GotId then
                exit;
        end;
        case UpdateType of
            UpdateType::EventUpdate:
                if GotId then begin
                    ReturnValue := SyncEvent(id, CalObject, CalendarJSSetup.CalendarCode); // return the event
                    exit;
                end;
            UpdateType::EventRemove:
                RemoveEvent(id);
            UpdateType::OptionsUpdate:
                SyncOptions(CalObject);
            UpdateType::SearchOptionsUpdate:
                SyncOptions(CalObject);
        end;
        ReturnValue.Add(ResultLbl, GotId);
    end;

    internal procedure SyncOptions(Options: JsonObject)
    var
        CalendarJsHelper: Codeunit PTECalendarJsJsonHelper;
        RecRef: RecordRef;
    begin
        RecRef.GetTable(CalendarJSSetup);
        CalendarJsHelper.JsonToRecord(RecRef, Options);
        RecRef.SetTable(CalendarJSSetup);
        CalendarJSSetup.Modify(true);
    end;

    internal procedure SyncSearchOptions(Options: JsonObject)
    var
        CalendarSearchOptions: Record PTECalendarJsSearchOption;
        CalendarJsHelper: Codeunit PTECalendarJsJsonHelper;
        RecRef: RecordRef;
    begin
        CalendarSearchOptions.Get(CalendarJSSetup.CalendarCode);
        RecRef.GetTable(CalendarSearchOptions);
        CalendarJsHelper.JsonToRecord(RecRef, Options);
        RecRef.SetTable(CalendarSearchOptions);
        CalendarSearchOptions.Modify(true);
    end;

    internal procedure SyncEvent(Id: Guid; CalEvent: JsonObject; CalendarCode: Code[20]) ReturnValue: JsonObject
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
            CalendarJsEvent.BCRecordSystemId := SourceRef.RecordId();
            CalendarJsEvent.TableNo := SourceRef.Number();
            CalendarJsEvent.CalendarCode := CalendarCode;
            CalendarJsEvent.Insert(true);
        end;

        RecRef.GetTable(CalendarJsEvent);
        CalendarJsHelper.JsonToRecord(RecRef, CalEvent);
        RecRef.SetTable(CalendarJsEvent);
        CalendarJsEvent.Modify(true);

        ReturnValue := CalendarJsHelper.RecordToJson(CalendarJsEvent);
    end;

    internal procedure RemoveEvent(Id: Guid)
    var
        CalendarJsEvent: Record PTECalendarJsEvent;
    begin
        CalendarJsEvent.Reset();
        CalendarJsEvent.SetRange(TableNo, SourceRef.Number());
        CalendarJsEvent.SetRange(Id, Id);
        if CalendarJsEvent.FindFirst() then
            CalendarJsEvent.Delete(true);
    end;
}
