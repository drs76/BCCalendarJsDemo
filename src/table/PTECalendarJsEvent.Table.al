table 50204 PTECalendarJsEvent
{
    Caption = 'CalendarJs Event';
    DataClassification = CustomerContent;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; CalendarCode; Code[20])
        {
            Caption = 'Calendar Code';
        }
        field(3; TableNo; Integer)
        {
            Caption = 'Table No.';
        }
        field(4; BCRecordSystemId; Guid)
        {
            Caption = 'BC Record SystemId';
        }
        field(5; Id; Guid)
        {
            Caption = 'Id';
        }
        field(6; Title; Text[2048])
        {
            Caption = 'Title';
        }
        field(7; DTFrom; DateTime)
        {
            Caption = 'From';
        }
        field(8; DTTo; DateTime)
        {
            Caption = 'To';
        }
        field(9; Description; Blob)
        {
            Caption = 'Description';
        }
        field(10; Location; Text[100])
        {
            Caption = 'Location';
        }
        field(11; Color; Text[10])
        {
            Caption = 'Color';
        }
        field(12; ColorText; Text[10])
        {
            Caption = 'ColorText';
        }
        field(13; ColorBorder; Text[10])
        {
            Caption = 'ColorBorder';
        }
        field(14; IsAllDay; Boolean)
        {
            Caption = 'IsAllDay';
        }
        field(15; RepeatEvery; Enum PTECalendarJSRepeatEvery)
        {
            Caption = 'Repeat Every';
        }
        field(16; RepeatEveryExcludeDays; Text[25])
        {
            Caption = 'RepeatEveryExcludeDays';
        }
        field(17; SeriesIgnoreDates; Blob)
        {
            Caption = 'SeriesIgnoreDates';
        }
        field(18; Created; DateTime)
        {
            Caption = 'Created';
        }
        field(19; OrganizerName; Text[250])
        {
            Caption = 'OrganizerName';
        }
        field(20; OrganizerEmailAddress; Text[1024])
        {
            Caption = 'OrganizerEmailAddress';
        }
        field(21; RepeatEnds; DateTime)
        {
            Caption = 'RepeatEnds';
        }
        field(22; EventGroup; Text[100])
        {
            Caption = 'Group';
        }
        field(23; Url; Text[1024])
        {
            Caption = 'Url';
        }
        field(24; repeatEveryCustomType; Enum PTECalendarJSRepeatEveryCustom)
        {
            Caption = 'RepeatEveryCustomType';
        }
        field(25; RepeatEveryCustomValue; Integer)
        {
            Caption = 'RepeatEveryCustomValue';
        }
        field(26; LastUpdated; DateTime)
        {
            Caption = 'LastUpdated';
        }
        field(27; ShowAlerts; Boolean)
        {
            Caption = 'ShowAlerts';
        }
        field(28; Locked; Boolean)
        {
            Caption = 'Locked';
        }
        field(29; EventType; Integer)
        {
            Caption = 'Type';
        }
        field(30; CustomTags; Text[1024])
        {
            Caption = 'CustomTags';
        }
        field(31; ShowAsBusy; Boolean)
        {
            Caption = 'ShowAsBusy';
        }
        field(32; AlertOffset; Integer)
        {
            Caption = 'AlertOffset';
        }
        field(1000; KeyField1; Code[50])
        {
            Caption = 'Key Field 1';
        }
        field(1001; KeyField2; Code[50])
        {
            Caption = 'Key Field 2';
        }
        field(1002; KeyField3; Code[50])
        {
            Caption = 'Key Field 3';
        }
        field(1003; KeyField4; Code[50])
        {
            Caption = 'Key Field 4';
        }
        field(1004; KeyField5; Code[50])
        {
            Caption = 'Key Field 5';
        }
    }

    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
        key(Key2; CalendarCode, Id)
        {
        }
        key(Key3; TableNo, DTFrom, DTTo, KeyField1, KeyField2, KeyField3, KeyField4, KeyField5)
        {
        }
    }

    var
        CalendarJsJsonHelper: Codeunit PTECalendarJsJsonHelper;


    internal procedure CreateCalendarEvent() ReturnValue: JsonObject
    begin
        ReturnValue := CalendarJsJsonHelper.RecordToJson(Rec);
    end;

    internal procedure UpdateCalendarEvent(EventJson: Text)
    var
        CalendarJSEvent: Record PTECalendarJsEvent;
        RecRef: RecordRef;
        EventJO: JsonObject;
        JToken: JsonToken;
        SysId: Guid;
        NewEvent: Boolean;
        IdLbl: Label 'id';
    begin
        EventJO.ReadFrom(EventJson);
        EventJO.Get(IdLbl, JToken);

        Evaluate(SysId, JToken.AsValue().AsText());
        NewEvent := not CalendarJSEvent.GetBySystemId(SysId);
        if NewEvent then
            CalendarJSEvent.Init();
        RecRef.GetTable(CalendarJSEvent);

        CalendarJsJsonHelper.JsonToRecord(RecRef, EventJO);
    end;

    internal procedure SetKeyData(KeyData: array[5] of Code[50])
    begin
        Rec.KeyField1 := KeyData[1];
        Rec.KeyField2 := KeyData[2];
        Rec.KeyField3 := KeyData[3];
        Rec.KeyField4 := KeyData[4];
        Rec.KeyField5 := KeyData[5];
    end;
}
