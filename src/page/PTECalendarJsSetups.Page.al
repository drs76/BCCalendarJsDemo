page 50208 PTECalendarJsSetups
{
    ApplicationArea = All;
    Caption = 'CalendarJs Setups';
    PageType = List;
    UsageCategory = Administration;
    SourceTable = PTECalendarJsSetup;
    CardPageId = PTECalendarJsSetup;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'Setups';
                Editable = false;

                field(CalendarCode; Rec.CalendarCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calendar Code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(OrganizerName; Rec.OrganizerName)
                {
                    ApplicationArea = All;
                    ToolTip = 'The default name of the organizer (defaults to an empty string).';
                }
                field(OrganizerEmailAddress; Rec.OrganizerEmailAddress)
                {
                    ApplicationArea = All;
                    ToolTip = 'The default email address of the organizer (defaults to an empty string).';
                }
                field(IsWidget; Rec.IsWidget)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the new calendar instance is only a widget (defaults to false).';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetLoadFields(CalendarCode, Description, OrganizerName, OrganizerEmailAddress, IsWidget);
    end;
}
