codeunit 50203 PTECalendarJsHelper
{
    internal procedure GetCalendarSettings(var CurrCalendar: Code[20]) ReturnValue: JsonObject
    var
        CalendarJsSetup: Record PTECalendarJsSetup;
        CalendarJsJsonHelper: Codeunit PTECalendarJsJsonHelper;
        ViewsLbl: Label 'views';
    begin
        CalendarJsSetup.SetRange(Default, true);
        if not CalendarJsSetup.FindFirst() then
            exit;

        CurrCalendar := CalendarJsSetup.CalendarCode;
        ReturnValue := CalendarJsJsonHelper.RecordToJson(CalendarJsSetup, false);
        ReturnValue.Add(ViewsLbl, GetCalendarViewSettings(CalendarJsSetup.CalendarCode));
    end;

    internal procedure GetCalendarSetup(var CurrCalendar: Code[20])
    var
        CalendarJsSetup: Record PTECalendarJsSetup;
    begin
        CalendarJsSetup.SetRange(Default, true);
        if not CalendarJsSetup.FindFirst() then
            exit;

        CurrCalendar := CalendarJsSetup.CalendarCode;
    end;

    internal procedure GetCalendarSearchSettings(CalCode: Code[20]) ReturnValue: JsonObject
    var
        CalendarJsSearchOption: Record PTECalendarJsSearchOption;
        CalendarJsJsonHelper: Codeunit PTECalendarJsJsonHelper;
    begin
        if not CalendarJsSearchOption.Get(CalCode) then
            exit;

        ReturnValue := CalendarJsJsonHelper.RecordToJson(CalendarJsSearchOption, false);
    end;

    internal procedure GetCalendarViewSettings(CalCode: Code[20]) ReturnValue: JsonObject
    var
        CalendarJsViewOption: Record PTECalendarJsViewOption;
        CalendarJsJsonHelper: Codeunit PTECalendarJsJsonHelper;
    begin
        CalendarJsViewOption.SetRange(CalendarCode, CalCode);
        if not CalendarJsViewOption.FindSet() then
            exit;

        repeat
            ReturnValue.Add(Format(CalendarJsViewOption.CalendarView), CalendarJsJsonHelper.RecordToJson(CalendarJsViewOption, false));
        until CalendarJsViewOption.Next() = 0;
    end;

    internal procedure LaunchCalendar(RecordForCalendar: Variant; WidgetMode: Boolean)
    var
        CalendarJsDemo: Page PTECalendarJsPart;
        RecRef: RecordRef;
    begin
        RecRef.GetTable(RecordForCalendar);
        CalendarJsDemo.InitCalendarSource(RecRef.Number(), RecRef.Field(RecRef.SystemIdNo).Value, WidgetMode);
    end;

    internal procedure BuildEvents(TableNo: Integer; KeyData: array[5] of Code[20]): JsonArray
    var
        CalendarJsEvent: Record PTECalendarJsEvent;
        OutValue: JsonArray;
    begin
        CalendarJsEvent.Reset();
        CalendarJsEvent.SetRange(TableNo, TableNo);
        CalendarJsEvent.SetRange(KeyField1, KeyData[1]);
        CalendarJsEvent.SetRange(KeyField2, KeyData[2]);
        CalendarJsEvent.SetRange(KeyField3, KeyData[3]);
        CalendarJsEvent.SetRange(KeyField4, KeyData[4]);
        if not CalendarJsEvent.FindSet() then
            exit;

        repeat
            OutValue.Add(CalendarJsEvent.CreateCalendarEvent());
        until CalendarJsEvent.Next() = 0;

        exit(OutValue);
    end;

}
