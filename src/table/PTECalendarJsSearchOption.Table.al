table 50202 PTECalendarJsSearchOption
{
    Caption = 'CalendarJs Search Option';
    DataClassification = CustomerContent;

    fields
    {
        field(1; CalendarCode; Code[20])
        {
            Caption = 'Calendar Code';
        }
        field(2; UseNot; Boolean)
        {
            Caption = 'UseNot';
            InitValue = false;
        }
        field(3; MatchCase; Boolean)
        {
            Caption = 'MatchCase';
            InitValue = false;

        }
        field(4; ShowAdvanced; Boolean)
        {
            Caption = 'ShowAdvanced';
            InitValue = false;
        }
        field(5; SearchTitle; Boolean)
        {
            Caption = 'SearchTitle';
            InitValue = false;
        }
        field(6; SearchLocation; Boolean)
        {
            Caption = 'SearchLocation';
            InitValue = false;
        }
        field(7; SearchDescription; Boolean)
        {
            Caption = 'SearchDescription';
            InitValue = false;
        }
        field(8; SearchGroup; Boolean)
        {
            Caption = 'SearchGroup';
            InitValue = false;
        }
        field(9; SearchUrl; Boolean)
        {
            Caption = 'SearchUrl';
            InitValue = false;
        }
        field(10; StartsWith; Boolean)
        {
            Caption = 'StartsWith';
            InitValue = false;
        }
        field(11; EndsWith; Boolean)
        {
            Caption = 'EndsWith';
            InitValue = false;
        }
        field(12; UseContains; Boolean)
        {
            Caption = 'UseContains';
            InitValue = true;
        }
        field(13; Enabled; Boolean)
        {
            Caption = 'Enabled';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; CalendarCode)
        {
            Clustered = true;
        }
    }

    internal procedure Create(CalCode: Code[20])
    begin
        Rec.Init();
        Rec.CalendarCode := CalCode;
        Rec.Insert(true);
    end;
}
