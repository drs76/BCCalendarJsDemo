page 50203 PTECalendarJsPart
{
    Caption = 'Calendar';
    AdditionalSearchTerms = 'calendar';
    PageType = CardPart;
    UsageCategory = None;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            usercontrol(PTECalendar; PTECalendarjsControl)
            {
                ApplicationArea = All;

                // Control addin is ready, we can use the calendar now.
                trigger ControlReady()
                var
                    Events: JsonArray;
                begin
                    SetupCalendar();

                    Events := CalendarPageMgt.BuildEvents();
                    CurrPage.PTECalendar.SetEvents(Events);

                    ControlReady := true;
                end;

                // ASYNC - Fires to get events for calendar
                trigger OnFetchEvents()
                var
                    Events: JsonArray;
                begin
                    Events := CalendarPageMgt.BuildEvents();
                    CurrPage.PTECalendar.OnFetchEventsResult(Events);
                end;

                // ASYNC - Fires when the calendar options are updated.
                trigger OnSyncOptionsBC(options: JsonObject)
                var
                    JResult: JsonObject;
                begin
                    CalendarPageMgt.HandleCalendarUpdate(options, CalendarUpdate::OptionsUpdate);
                    CurrPage.PTECalendar.OnSyncOptionsBCResult(JResult);
                end;

                // ASYNC - Fires when the calendar search options are updated.
                trigger OnSyncSearchOptionsBC(options: JsonObject)
                var
                    JResult: JsonObject;
                begin
                    CalendarPageMgt.HandleCalendarUpdate(options, CalendarUpdate::SearchOptionsUpdate);
                    CurrPage.PTECalendar.OnSyncSearchOptionsBCResult(JResult);
                end;

                // ASYNC - Fires when an entry on the Calendar is updated.
                trigger OnModEvent2BC(entry: JsonObject)
                var
                    JResult: JsonObject;
                begin
                    JResult := CalendarPageMgt.HandleCalendarUpdate(entry, CalendarUpdate::EventUpdate);
                    CurrPage.PTECalendar.OnModEvent2BCResult(JResult);
                end;

                // ASYNC - Fires when an entry on the Calendar is removed.
                trigger OnRemoveEventFromBC(entry: JsonObject)
                var
                    JResult: JsonObject;
                begin
                    JResult := CalendarPageMgt.HandleCalendarUpdate(entry, CalendarUpdate::EventRemove);
                    CurrPage.PTECalendar.OnRemoveEventFromBCResult(JResult);
                end;
            }
        }
    }

    var
        CalendarJSSetup: Record PTECalendarJsSetup;
        CalendarPageMgt: Codeunit PTECalendarPageMgt;
        SourceRef: RecordRef;
        KeyData: array[5] of Code[50];
        CalendarUpdate: Option OptionsUpdate,SearchOptionsUpdate,EventUpdate,EventRemove;
        CurrCalCode: Code[20];
        IsWidget: Boolean;
        ControlReady: Boolean;

    internal procedure InitCalendarSource(TableNo: Integer; RecSysId: Guid; InIsWidget: Boolean)
    var
        CalendarJsHelper: Codeunit PTECalendarJsHelper;
        KeyRef: KeyRef;
        Events: JsonArray;
        i: Integer;
    begin
        IsWidget := InIsWidget;
        if SourceRef.Number() <> 0 then
            SourceRef.Close();
        SourceRef.Open(TableNo);
        SourceRef.GetBySystemId(RecSysId);

        KeyRef := SourceRef.KeyIndex(1);//PK
        for i := 1 to KeyRef.FieldCount() do
            KeyData[i] := Format(KeyRef.FieldIndex(i));

        CalendarJsHelper.GetCalendarSetup(CurrCalCode);
        CalendarJSSetup.Get(CurrCalCode);
        CalendarPageMgt.SetCalendarSetup(CalendarJSSetup, SourceRef, KeyData);
        if not ControlReady then
            exit;

        Events := CalendarPageMgt.BuildEvents();
        CurrPage.PTECalendar.SetEvents(Events);
    end;

    local procedure SetupCalendar()
    var
        CalendarJsHelper: Codeunit PTECalendarJsHelper;
        Options: JsonObject;
    begin
        Options := CalendarJsHelper.GetCalendarSettings(CurrCalCode); //setup & show calendar with initial view
        if Options.Contains('searchOptions') then
            Options.Remove('searchOptions');

        Options.Add('searchOptions', CalendarJsHelper.GetCalendarSearchSettings(CurrCalCode));
        CurrPage.PTECalendar.InitCalendar(Options, IsWidget); //setup & show calendar with initial view
    end;

}
