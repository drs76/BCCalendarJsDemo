codeunit 50203 PTECalendarJsHelper
{
    internal procedure GetCalendarSettings() ReturnValue: JsonObject
    var
        CalendarJsSetup: Record PTECalendarJsSetup;
        CalendarJsJsonHelper: Codeunit PTECalendarJsJsonHelper;
    begin
        CalendarJsSetup.SetRange(Default, true);
        if not CalendarJsSetup.FindFirst() then
            exit;

        ReturnValue := CalendarJsJsonHelper.RecordToJson(CalendarJsSetup, false);
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

    internal procedure GetCalendarViewSettings(CalCode: Code[20]; ViewType: Enum PTECalendarJSViews) ReturnValue: JsonObject
    var
        CalendarJsViewOption: Record PTECalendarJsViewOption;
        CalendarJsJsonHelper: Codeunit PTECalendarJsJsonHelper;
    begin
        if not CalendarJsViewOption.Get(CalCode, ViewType) then
            exit;

        ReturnValue := CalendarJsJsonHelper.RecordToJson(CalendarJsViewOption, false);
    end;

    internal procedure CreateConstraint(StartTime: Time; EndTime: Time; DaysOfWeek: Text) Constraint: JsonObject
    var
        StartTimeLbl: Label 'startTime';
        EndTimeLbl: Label 'endTime';
        DaysOfWeekLbl: Label 'daysOfWeek';
        TimeFormatTxt: Label '<Hours24,2><Filler Character,0>:<Minutes,2>';
        EmptyTxt: Label '';
    begin
        Constraint.Add(StartTimeLbl, Format(StartTime, 0, TimeFormatTxt));
        Constraint.Add(EndTimeLbl, Format(EndTime, 0, TimeFormatTxt));
        if DaysOfWeek <> EmptyTxt then
            Constraint.Add(DaysOfWeekLbl, DaysOfWeek);
    end;

    internal procedure GetCalendarDateRange(fetchInfo: JsonObject; var FirstDate: Date; var LastDate: Date)
    var
        JToken: JsonToken;
        StartLbl: Label 'startStr';
        EndLbl: Label 'endStr';
        AddMonthTxt: Label '<+3M>';
    begin
        // set defaults (they will be used to get the draggable external events on first call)
        FirstDate := 0D;
        LastDate := CalcDate(AddMonthTxt, Today());

        if fetchInfo.Get(StartLbl, JToken) then
            if Evaluate(FirstDate, CopyStr(JToken.AsValue().AsText(), 1, 10)) then;

        if fetchInfo.Get(EndLbl, JToken) then
            if Evaluate(LastDate, CopyStr(JToken.AsValue().AsText(), 1, 10)) then;
    end;

    internal procedure BuildAddressString(SalesHeader: Record "Sales Header"): Text
    var
        AddressTB: TextBuilder;
        SalesOrderLbl: Label 'Sales Order: %1', Comment = '%1 = Sales Order No.';
    begin
        AddAddressLine(AddressTB, StrSubstNo(SalesOrderLbl, SalesHeader."No."));
        AddAddressLine(AddressTB, SalesHeader."Sell-to Customer Name");
        AddAddressLine(AddressTB, SalesHeader."Sell-to Customer Name 2");
        AddAddressLine(AddressTB, SalesHeader."Sell-to Address");
        AddAddressLine(AddressTB, SalesHeader."Sell-to Address 2");
        AddAddressLine(AddressTB, SalesHeader."Sell-to City");
        AddAddressLine(AddressTB, SalesHeader."Sell-to County");
        AddAddressLine(AddressTB, SalesHeader."Sell-to Post Code");
        AddAddressLine(AddressTB, SalesHeader."Sell-to Country/Region Code");
        exit(AddressTB.ToText());
    end;

    local procedure AddAddressLine(var AddressTB: TextBuilder; AddressLine: Text)
    var
        EmptyTxt: Label '';
    begin
        if AddressLine <> EmptyTxt then
            AddressTB.AppendLine(AddressLine);
    end;

    internal procedure GetEventDate(ShipDate: Date; ShipTime: Time): DateTime
    begin
        exit(CreateDateTime(ShipDate, ShipTime));
    end;
}
