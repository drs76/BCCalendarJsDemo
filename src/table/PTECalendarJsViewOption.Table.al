table 50201 PTECalendarJsViewOption
{
    Caption = 'CalendarJs View Option';
    DataClassification = CustomerContent;

    fields
    {
        field(1; CalendarCode; Code[20])
        {
            Caption = 'Calendar Code';
        }
        field(2; CalendarView; Enum PTECalendarJSViews)
        {
            Caption = 'views';
            NotBlank = true;
        }
        field(3; ShowAllDayEventDetails; Boolean)
        {
            Caption = 'ShowAllDayEventDetails';
            InitValue = false;
        }
        field(4; MinutesBetweenSections; Integer)
        {
            Caption = 'MinutesBetweenSections';
            InitValue = 30;
        }
        field(5; ShowTimelineArrow; Boolean)
        {
            Caption = 'ShowTimelineArrow';
            InitValue = true;
        }
        field(6; ShowExtraTitleBarButtons; Boolean)
        {
            Caption = 'ShowExtraTitleBarButtons';
            InitValue = true;
        }
        field(7; ShowDayNamesHeaders; Boolean)
        {
            Caption = 'ShowDayNamesHeaders';
            InitValue = true;
        }
        field(8; ShowWeekNumbersInTitles; Boolean)
        {
            Caption = 'ShowWeekNumbersInTitles';
            InitValue = false;
        }
        field(9; MaximumEventsPerDayDisplay; Integer)
        {
            Caption = 'MaximumEventsPerDayDisplay';
            InitValue = 3;
        }
        field(10; AllowEventScrolling; Boolean)
        {
            Caption = 'AllowEventScrolling';
            InitValue = false;
        }
        field(11; ShowTimesInEvents; Boolean)
        {
            Caption = 'ShowTimtrueesInEvents';
            InitValue = false;
        }
        field(12; MinimumDayHeight; Integer)
        {
            Caption = 'MinimumDayHeight';
            InitValue = 0;
        }
        field(13; ShowPreviousNextMonthNames; Boolean)
        {
            Caption = 'ShowPreviousNextMonthNames';
            InitValue = true;
        }
        field(14; UseOnlyDotEvents; Boolean)
        {
            Caption = 'UseOnlyDotEvents';
            InitValue = false;
        }
        field(15; ApplyCssToEventsNotInCurrMonth; Boolean)
        {
            Caption = 'ApplyCssToEventsNotInCurrentMonth';
            InitValue = true;
        }
        field(16; AddYearButtons; Boolean)
        {
            Caption = 'AddYearButtons';
            InitValue = false;
        }
        field(17; TitleBarDateFormat; Text[50])
        {
            Caption = 'TitleBarDateFormat';
            InitValue = '{mmmm} {yyyy}';
        }
        field(18; IsPinUpViewEnabled; Boolean)
        {
            Caption = 'IsPinUpViewEnabled';
            InitValue = false;
        }
        field(19; PinUpViewImageUrls; Blob)
        {
            Caption = 'PinUpViewImageUrls';
        }
        field(20; ShowMonthButtonsInYearDropDown; Boolean)
        {
            Caption = 'ShowMonthButtonsInYearDropDownMenu';
            InitValue = true;
        }
        field(21; DefaultAxis; Text[50])
        {
            Caption = 'DefaultAxis';
            InitValue = 'group';
        }
    }

    keys
    {
        key(PK; CalendarCode, CalendarView)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; CalendarCode, CalendarView)
        {
        }
    }

    internal procedure Create(CalCode: Code[20]; ViewType: Enum PTECalendarJSViews)
    begin
        Rec.Init();
        Rec.CalendarCode := CalCode;
        Rec.CalendarView := ViewType;
        Rec.Insert(true);
    end;
}
