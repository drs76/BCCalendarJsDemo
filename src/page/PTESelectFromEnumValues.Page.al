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
    begin
        DisplayText := ValuesDict.Get(Rec.Number);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        DisplayText := ValuesDict.Get(Rec.Number);
    end;

    var
        ValuesDict: Dictionary of [Integer, Text];
        DisplayText: Text;


    internal procedure SetForDaysOfWeek(CurrentValue: Text)
    var
        DayOfWeek: Text;
        Id: Integer;
    begin
        foreach DayOfWeek in PTECalendarJsDaysOfWeek.Names() do begin
            Id += 1;
            ValuesDict.Add(Id, DayOfWeek);
        end;
        Rec.SetRange(Number, 1, Id);
    end;

    internal procedure SetForViews(CurrentValue: Text)
    var
        CalendarView: Text;
        Id: Integer;
    begin
        foreach CalendarView in PTECalendarJsViews.Names() do begin
            Id += 1;
            ValuesDict.Add(Id, CalendarView);
        end;
        Rec.SetRange(Number, 1, Id);
    end;

    internal procedure GetSelectedValues() ReturnValue: Text;
    var
        Selection: Record Integer;
        Formatted: TextBuilder;
        ValueText: Text;
        OpenCloseLbl: Label '[%1]';
        CommaLbl: Label ', ';
    begin
        CurrPage.SetSelectionFilter(Selection);
        if Selection.FindSet() then
            repeat
                ValueText := ValuesDict.Get(Selection.Number);
                if Formatted.Length() > 0 then
                    Formatted.Append(CommaLbl);
                Formatted.Append(ValueText);
            until Selection.Next() = 0;

        ReturnValue := StrSubstNo(OpenCloseLbl, Formatted.ToText());
    end;
}
