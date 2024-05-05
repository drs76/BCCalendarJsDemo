page 50212 PTECalendarJsEvents
{
    ApplicationArea = All;
    Caption = 'CalendarJs Events';
    PageType = List;
    SourceTable = PTECalendarJsEvent;
    UsageCategory = Administration;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;

                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                }
                field(DTFrom; Rec.DTFrom)
                {
                    ApplicationArea = All;
                }
                field(DTTo; Rec.DTTo)
                {
                    ApplicationArea = All;
                }
                field(BCRecordSystemId; Rec.BCRecordSystemId)
                {
                    ApplicationArea = All;
                }
                field(Description; DescriptionText)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field(Color; Rec.Color)
                {
                    ApplicationArea = All;
                }
                field(ColorBorder; Rec.ColorBorder)
                {
                    ApplicationArea = All;
                }
                field(ColorText; Rec.ColorText)
                {
                    ApplicationArea = All;
                }
                field(IsAllDay; Rec.IsAllDay)
                {
                    ApplicationArea = All;
                }
                field(RepeatEvery; Rec.RepeatEvery)
                {
                    ApplicationArea = All;
                }
                field(RepeatEveryExcludeDays; Rec.RepeatEveryExcludeDays)
                {
                    ApplicationArea = All;
                }
                field(RepeatEveryCustomValue; Rec.RepeatEveryCustomValue)
                {
                    ApplicationArea = All;
                }
                field(repeatEveryCustomType; Rec.repeatEveryCustomType)
                {
                    ApplicationArea = All;
                }
                field(RepeatEnds; Rec.RepeatEnds)
                {
                    ApplicationArea = All;
                }
                field(OrganizerName; Rec.OrganizerName)
                {
                    ApplicationArea = All;
                }
                field(OrganizerEmailAddress; Rec.OrganizerEmailAddress)
                {
                    ApplicationArea = All;
                }
                field(Group; Rec.EventGroup)
                {
                    ApplicationArea = All;
                }
                field(Url; Rec.Url)
                {
                    ApplicationArea = All;
                }
                field(ShowAlerts; Rec.ShowAlerts)
                {
                    ApplicationArea = All;
                }
                field(Locked; Rec.Locked)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.EventType)
                {
                    ApplicationArea = All;
                }
                field(CustomTags; CustomTagsText)
                {
                    ApplicationArea = All;
                    Caption = 'Custom Tags';
                }
                field(AlertOffset; Rec.AlertOffset)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        DescriptionText: Text;
        CustomTagsText: Text;
}
