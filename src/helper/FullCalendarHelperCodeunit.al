/// <summary>
/// Codeunit PTEFullCalendarHelper (ID 50103).
/// </summary>
codeunit 50103 PTEFullCalendarHelper
{
    /// <summary>
    /// CreateConstraint.
    /// DaysOfWeek is zero based array 0=Sunday. 
    /// Pass days as text in brackets i.e. [1,2,3,4,5,6,0] = Mon-Sun
    /// </summary>
    /// <param name="StartTime">Time.</param>
    /// <param name="EndTime">Time.</param>
    /// <param name="DaysOfWeek">Text.</param>
    /// <returns>Return variable Constraint of type JsonObject.</returns>
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

    /// <summary>
    /// GetCalendarDateRange.
    /// </summary>
    /// <param name="fetchInfo">JsonObject.</param>
    /// <param name="FirstDate">VAR Date.</param>
    /// <param name="LastDate">VAR Date.</param>
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

    /// <summary>
    /// BuildAddressString
    /// </summary>
    /// <param name="SalesHeader">Record "Sales Header".</param>
    /// <returns>Text.</returns>
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

    /// <summary>
    /// AddAddressLine
    /// </summary>
    /// <param name="AddressTB">TextBuilder.</param>
    /// <param name="AddressLine">Text.</param>
    local procedure AddAddressLine(var AddressTB: TextBuilder; AddressLine: Text)
    var
        EmptyTxt: Label '';
    begin
        if AddressLine <> EmptyTxt then
            AddressTB.AppendLine(AddressLine);
    end;

    /// <summary>
    /// GetEventDate.
    /// Demo function
    /// </summary>
    /// <param name="ShipDate">Date.</param>
    /// <param name="ShipTime">Time.</param>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetEventDate(ShipDate: Date; ShipTime: Time): DateTime
    begin
        exit(CreateDateTime(ShipDate, ShipTime));
    end;
}
