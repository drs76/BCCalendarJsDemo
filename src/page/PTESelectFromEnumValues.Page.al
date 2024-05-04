page 50207 PTESelectFromEnumValues
{
    ApplicationArea = All;
    Caption = 'Select';
    PageType = List;
    UsageCategory = None;
    SourceTable = Integer;
    Editable = false;
    LinksAllowed = false;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DisplayText; DisplayText)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the name field.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Value: Integer;
    begin
        NameValue := ValuesDict.Get(Rec.Number);
        SplitNameValue(DisplayText, Value);
    end;

    trigger OnAfterGetCurrRecord()
    var
        Value: Integer;
    begin
        NameValue := ValuesDict.Get(Rec.Number);
        SplitNameValue(DisplayText, Value);
    end;

    var
        ValuesDict: Dictionary of [Integer, Dictionary of [Text, Integer]];
        NameValue: Dictionary of [Text, Integer];
        DisplayText: Text;


    internal procedure SetForDaysOfWeek(CurrentValue: Text)
    var
        Days: Enum PTECalendarJsDaysOfWeek;
        DayOfWeek: Text;
        Id: Integer;
    begin
        foreach DayOfWeek in PTECalendarJsDaysOfWeek.Names() do begin
            Id += 1;
            Clear(NameValue);
            Days := PTECalendarJsDaysOfWeek.FromInteger(Days.Ordinals().Get(Days.Names.IndexOf(DayOfWeek)));
            NameValue.Add(DayOfWeek, Days.AsInteger());
            ValuesDict.Add(Id, NameValue);
        end;
        Rec.SetRange(Number, 1, Id);
    end;

    internal procedure SetForViews(CurrentValue: Text)
    var
        Views: Enum PTECalendarJSViews;
        CalendarView: Text;
        Id: Integer;
    begin
        foreach CalendarView in PTECalendarJsViews.Names() do begin
            Id += 1;
            Clear(NameValue);
            Views := PTECalendarJsViews.FromInteger(Views.Ordinals().Get(Views.Names.IndexOf(CalendarView)));
            NameValue.Add(CalendarView, Views.AsInteger());
            ValuesDict.Add(Id, NameValue);
        end;
        Rec.SetRange(Number, 1, Id);
    end;

    internal procedure GetSelectedValues() ReturnValue: Text;
    var
        Selection: Record Integer;
        Formatted: TextBuilder;
        ValueText: Text;
        Value: Integer;
        OpenCloseLbl: Label '[%1]';
        CommaLbl: Label ', ';
    begin
        CurrPage.SetSelectionFilter(Selection);
        if Selection.FindSet() then
            repeat
                NameValue := ValuesDict.Get(Selection.Number);
                SplitNameValue(ValueText, Value);
                if Formatted.Length() > 0 then
                    Formatted.Append(CommaLbl);
                Formatted.Append(Format(Value));
            until Selection.Next() = 0;

        ReturnValue := StrSubstNo(OpenCloseLbl, Formatted.ToText());
    end;

#pragma warning disable AA0150
    local procedure SplitNameValue(var ValueText: Text; var Value: Integer)
#pragma warning restore AA0150
    begin
        foreach ValueText in NameValue.Keys() do
            Value := NameValue.Get(ValueText);
    end;
}
