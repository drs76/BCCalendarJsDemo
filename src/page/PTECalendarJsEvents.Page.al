page 50212 PTECalendarJsEvents
{
    ApplicationArea = All;
    Caption = 'CalendarJs Events';
    AdditionalSearchTerms = 'CalendarJs,Events,Event,Schedule';
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
                field(BCRecordSystemId; Format(Rec.BCRecordSystemId))
                {
                    ApplicationArea = All;
                    Caption = 'BC RecordId';
                    ToolTip = 'Specifies the value of the BC Record Id field.';
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

    actions
    {
        area(Processing)
        {
            action(Export2Json)
            {
                ApplicationArea = All;
                Caption = 'Export';
                ToolTip = 'Export Event to Json.';
                Image = Export;

                trigger OnAction()
                var
                    JsonHelper: Codeunit PTECalendarJsJsonHelper;
                    TempBlob: Codeunit "Temp Blob";
                    WriteStream: OutStream;
                    ReadStream: InStream;
                    Output: JsonObject;
                    JsonText: Text;
                    Filename: Text;
                begin
                    TempBlob.CreateOutStream(WriteStream, TextEncoding::UTF8);

                    Output := JsonHelper.RecordToJson(Rec);
                    Output.WriteTo(JsonText);
                    WriteStream.WriteText(JsonText);
                    TempBlob.CreateInStream(ReadStream, TextEncoding::UTF8);

                    DownloadFromStream(ReadStream, '', '', '', Filename);
                end;
            }
        }
    }

    var
        DescriptionText: Text;
        CustomTagsText: Text;
}
