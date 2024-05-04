table 50200 PTECalendarJsSetup
{
    Caption = 'PTECalendarJsSetup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; CalendarCode; Code[20])
        {
            Caption = 'Calendar Code';
            NotBlank = true;
        }
        field(2; ShowDayNumberOrdinals; Boolean)
        {
            Caption = 'ShowDayNumberOrdinals';
            InitValue = true;
        }
        field(3; DragAndDropForEventsEnabled; Boolean)
        {
            Caption = 'DragAndDropForEventsEnabled';
            InitValue = true;
        }
        field(4; ExportEventsEnabled; Boolean)
        {
            Caption = 'ExportEventsEnabled';
            InitValue = true;
        }
        field(5; ManualEditingEnabled; Boolean)
        {
            Caption = 'ManualEditingEnabled';
            InitValue = true;
        }
        field(6; AutoRefreshTimerDelay; Integer)
        {
            Caption = 'AutoRefreshTimerDelay';
            InitValue = 30000;
        }
        field(7; FullScreenModeEnabled; Boolean)
        {
            Caption = 'FullScreenModeEnabled';
            InitValue = true;
        }
        field(8; TooltipDelay; Integer)
        {
            Caption = 'TooltipDelay';
            InitValue = 1000;
        }
        field(9; Holidays; Blob)
        {
            Caption = 'Holidays';
        }
        field(10; OrganizerName; Text[250])
        {
            Caption = 'OrganizerName';
        }
        field(11; OrganizerEmailAddress; Text[1024])
        {
            Caption = 'OrganizerEmailAddress';
        }
        field(12; Spacing; Integer)
        {
            Caption = 'Spacing';
            InitValue = 10;
        }
        field(13; MaximumEventTitleLength; Integer)
        {
            Caption = 'MaximumEventTitleLength';
        }
        field(14; MaximumEventDescriptionLength; Integer)
        {
            Caption = 'MaximumEventDescriptionLength';
        }
        field(15; MaximumEventLocationLength; Integer)
        {
            Caption = 'MaximumEventLocationLength';
        }
        field(16; MaximumEventGroupLength; Integer)
        {
            Caption = 'MaximumEventGroupLength';
        }
        field(17; EventNotificationsEnabled; Boolean)
        {
            Caption = 'EventNotificationsEnabled';
        }
        field(18; TooltipsEnabled; Boolean)
        {
            Caption = 'TooltipsEnabled';
        }
        field(19; VisibleDays; Text[150])
        {
            Caption = 'VisibleDays';
            InitValue = '[ 0, 1, 2, 3, 4, 5, 6 ]';
            Editable = false;
        }
        field(20; UrlWindowTarget; Text[50])
        {
            Caption = 'UrlWindowTarget';
            InitValue = '_blank';
        }
        field(21; DefaultEventBackgroundColor; Text[10])
        {
            Caption = 'DefaultEventBackgroundColor';
            InitValue = '#484848';
        }
        field(22; DefaultEventTextColor; Text[10])
        {
            Caption = 'DefaultEventTextColor';
            InitValue = '#F5F5F5';
        }
        field(23; DefaultEventBorderColor; Text[10])
        {
            Caption = 'DefaultEventBorderColor';
            InitValue = '#282828';
        }
        field(24; OpenInFullScreenMode; Boolean)
        {
            Caption = 'OpenInFullScreenMode';
            InitValue = false;
        }
        field(25; HideEventsWithoutGroupAssigned; Boolean)
        {
            Caption = 'HideEventsWithoutGroupAssigned';
            InitValue = false;
        }
        field(26; ShowHolidays; Boolean)
        {
            Caption = 'ShowHolidays';
            InitValue = true;
        }
        field(27; UseTemplateWhenAddingNewEvent; Boolean)
        {
            Caption = 'UseTemplateWhenAddingNewEvent';
            InitValue = true;
        }
        field(28; UseEscapeKeyToExitFullScreen; Boolean)
        {
            Caption = 'UseEscapeKeyToExitFullScreenMode';
            InitValue = true;
        }
        field(29; AllowHtmlInDisplay; Boolean)
        {
            Caption = 'AllowHtmlInDisplay';
        }
        field(30; WeekendDays; Text[150])
        {
            Caption = 'WeekendDays';
            InitValue = '[ 0, 1, 2, 3, 4, 5, 6 ]';
            Editable = false;
        }
        field(32; SearchOptions; Code[20])
        {
            Caption = 'SearchOptions';
        }
        field(33; WorkingDays; Text[150])
        {
            Caption = 'WorkingDays';
            InitValue = '[ 0, 1, 2, 3, 4, 5, 6 ]';
            Editable = false;
        }
        field(34; MinimumYear; Integer)
        {
            Caption = 'MinimumYear';
            InitValue = 1900;
        }
        field(35; MaximumYear; Integer)
        {
            Caption = 'MaximumYear';
            InitValue = 2099;
        }
        field(36; DefaultEventDuration; Integer)
        {
            Caption = 'DefaultEventDuration';
            InitValue = 30;
        }
        field(37; ConfigurationDialogEnabled; Boolean)
        {
            Caption = 'ConfigurationDialogEnabled';
            InitValue = true;
        }
        field(38; PopUpNotificationsEnabled; Boolean)
        {
            Caption = 'PopUpNotificationsEnabled';
            InitValue = true;
        }
        field(39; StartOfWeekDay; Enum PTECalendarJsDaysOfWeek)
        {
            Caption = 'StartOfWeekDay';
            InitValue = 0;
        }
        field(40; ShortcutKeysEnabled; Boolean)
        {
            Caption = 'ShortcutKeysEnabled';
            InitValue = true;
        }
        field(41; WorkingHoursStart; Blob)
        {
            Caption = 'WorkingHoursStart';
        }
        field(42; WorkingHoursEnd; Blob)
        {
            Caption = 'WorkingHoursEnd';
        }
        field(43; ReverseOrderDaysOfWeek; Boolean)
        {
            Caption = 'ReverseOrderDaysOfWeek';
        }
        field(44; ImportEventsEnabled; Boolean)
        {
            Caption = 'ImportEventsEnabled';
            InitValue = true;
        }
        field(45; UseAmPmForTimeDisplays; Boolean)
        {
            Caption = 'UseAmPmForTimeDisplays';
        }
        field(46; IsWidget; Boolean)
        {
            Caption = 'IsWidget';
        }
        field(47; ViewToOpenOnFirstLoad; Enum PTECalendarJsViews)
        {
            Caption = 'ViewToOpenOnFirstLoad';
        }
        field(48; EventColorsEditingEnabled; Boolean)
        {
            Caption = 'EventColorsEditingEnabled';
            InitValue = true;
        }
        field(49; SideMenuShowDays; Boolean)
        {
            Caption = 'SideMenuShowDays';
            InitValue = true;
        }
        field(50; SideMenuShowGroups; Boolean)
        {
            Caption = 'SideMenuShowGroups';
            InitValue = true;
        }
        field(51; SideMenuShowEventTypes; Boolean)
        {
            Caption = 'SideMenuShowEventTypes';
            InitValue = true;
        }
        field(52; SideMenuShowWorkingDays; Boolean)
        {
            Caption = 'SideMenuShowWorkingDays';
            InitValue = true;
        }
        field(53; SideMenuDhowWeekendDays; Boolean)
        {
            Caption = 'SideMenuDhowWeekendDays';
            InitValue = true;
        }
        field(100; Default; Boolean)
        {
            Caption = 'Default';

            trigger OnValidate()
            var
                CalendarJsSetup: Record PTECalendarJsSetup;
            begin
                if Rec.Default then begin
                    CalendarJsSetup.SetFilter(CalendarCode, '<>%1', Rec.CalendarCode);
                    CalendarJsSetup.SetRange(Default, true);
                    if not CalendarJsSetup.IsEmpty() then
                        CalendarJsSetup.ModifyAll(Default, false);
                end;
            end;
        }
        field(101; Description; Text[250])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; CalendarCode)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        SetupDefaults();
    end;

    trigger OnDelete()
    begin
        DeleteRelated();
    end;

    internal procedure AssistForDaysOfWeek(var SelectFromEnum: Page PTESelectFromEnumValues; var ReturnValue: Text[150])
    begin
        SelectFromEnum.LookupMode(true);
        if SelectFromEnum.RunModal() = Action::LookupOK then
            ReturnValue := CopyStr(SelectFromEnum.GetSelectedValues(), 1, MaxStrLen(ReturnValue));
    end;

    local procedure SetupDefaults()
    var
        CalendarJsViewOptions: Record PTECalendarJsViewOption;
        CalendarJsSearchOptions: Record PTECalendarJsSearchOption;
        Views: Enum PTECalendarJSViews;
        View: Text;
    begin
        foreach View in PTECalendarJSViews.Names() do
            CalendarJSViewOptions.Create(Rec.CalendarCode, PTECalendarJsViews.FromInteger(Views.Ordinals().Get(Views.Names().IndexOf(View))));

        CalendarJsSearchOptions.Create(Rec.CalendarCode);
    end;

    local procedure DeleteRelated();
    var
        CalendarJsViewOptions: Record PTECalendarJsViewOption;
        CalendarJsSearchOptions: Record PTECalendarJsSearchOption;
    begin
        CalendarJsSearchOptions.SetRange(CalendarCode, Rec.CalendarCode);
        if not CalendarJSSearchOptions.IsEmpty() then
            CalendarJsSearchOptions.DeleteAll(true);

        CalendarJsViewOptions.SetRange(CalendarCode, Rec.CalendarCode);
        if not CalendarJSViewOptions.IsEmpty() then
            CalendarJsViewOptions.DeleteAll(true);
    end;
}
