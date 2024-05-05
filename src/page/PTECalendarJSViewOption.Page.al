page 50205 PTECalendarJSViewOption
{
    Caption = 'CalendarJs View Options Card';
    PageType = Card;
    SourceTable = PTECalendarJsViewOption;
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(FullDay)
            {
                Caption = 'Options';
                Visible = Rec.CalendarView = PTECalendarJsViews::fullDay;

                field("Calendar View"; Rec.CalendarView)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ShowAllDayEventDetails; Rec.ShowAllDayEventDetails)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the extra details for an All Day event should be shown (defaults to false).';
                }
                field(MinutesBetweenSections; Rec.MinutesBetweenSections)
                {
                    ApplicationArea = All;
                    ToolTip = 'States the number of minutes that should be used between rows in all views (defaults to 30).';
                }
                field(ShowTimelineArrow; Rec.ShowTimelineArrow)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the timeline arrow should be shown (defaults to true).';
                }
                field(ShowExtraTitleBarButtons; Rec.ShowExtraTitleBarButtons)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the extra toolbar buttons on the main title bars are visible (defaults to true).';
                }
            }
            group(FullWeek)
            {
                Visible = Rec.CalendarView = Rec.CalendarView::fullWeek;

                field(ShowAllDayEventDetailsFullWeek; Rec.ShowAllDayEventDetails)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the extra details for an All Day event should be shown (defaults to false).';
                }
                field(ShowDayNamesHeaders; Rec.ShowDayNamesHeaders)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the day names headers should be shown (defaults to true).';
                }
                field(MinutesBetweenSectionsFullWeek; Rec.MinutesBetweenSections)
                {
                    ApplicationArea = All;
                    ToolTip = 'States the number of minutes that should be used between rows in all views (defaults to 30).';
                }
                field(ShowTimelineArrowFullWeek; Rec.ShowTimelineArrow)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the timeline arrow should be shown (defaults to true).';
                }
                field(ShowWeekNumbersInTitles; Rec.ShowWeekNumbersInTitles)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if week numbers should be shown in the title bars (defaults to false).';
                }
                field(ShowExtraTitleBarButtonsFullWeek; Rec.ShowExtraTitleBarButtons)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the extra toolbar buttons on the main title bars are visible (defaults to true).';
                }
            }
            group(FullMonth)
            {
                Visible = Rec.CalendarView = Rec.CalendarView::fullMonth;
                field(MaximumEventsPerDayDisplay; Rec.MaximumEventsPerDayDisplay)
                {
                    ApplicationArea = All;
                    ToolTip = 'The maximum number of events that should be displayed per day (defaults to 3, 0 disables it).';
                }
                field(AllowEventScrolling; Rec.AllowEventScrolling)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the days in the display can be scrolled (defaults to false, overrides maximumEventsPerDayDisplay if true).';
                }
                field(ShowTimesInEvents; Rec.ShowTimesInEvents)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the time should be shown on the events (defaults to false).';
                }
                field(MinimumDayHeight; Rec.MinimumDayHeight)
                {
                    ApplicationArea = All;
                    ToolTip = 'States the height the days should use (defaults to 0 - auto).';
                }
                field(ShowPreviousNextMonthNames; Rec.ShowPreviousNextMonthNames)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the previous/next month names should be shown in the days (defaults to true).';
                }
                field(UseOnlyDotEvents; Rec.UseOnlyDotEvents)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if only dot event icons should be used (to save space, defaults to false).';
                }
                field(ApplyCssToEventsNotInCurrMonth; Rec.ApplyCssToEventsNotInCurrMonth)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if extra CSS should be applied to events that are not in the current (defaults to true).';
                }
                field(AddYearButtons; Rec.AddYearButtons)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the year-jumping buttons should be added (defaults to false).';
                }
                field(TitleBarDateFormat; Rec.TitleBarDateFormat)
                {
                    ApplicationArea = All;
                    ToolTip = 'States the display format that should be used for the title bar (defaults to “{mmmm} {yyyy}”, see date display formats https://calendar-js.com/documentation/DATE_FORMATS.md for options).';
                }
                field(ShowDayNamesHeadersFullMonth; Rec.ShowDayNamesHeaders)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the day names headers should be shown (defaults to true).';
                }
                field(IsPinUpViewEnabled; Rec.IsPinUpViewEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the pin-up view is enabled (defaults to false).';
                }
                field(ShowMonthButtonsInYearDropDown; Rec.ShowMonthButtonsInYearDropDown)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the month name selector buttons are shown in the Year Drop-Down menu (defaults to true).';
                }
                field(ShowExtraTitleBarButtonsFullWeekFullMonth; Rec.ShowExtraTitleBarButtons)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the extra toolbar buttons on the main title bars are visible (defaults to true).';
                }
            }
            group(FullYear)
            {
                Visible = Rec.CalendarView = Rec.CalendarView::fullYear;

                field(ShowExtraTitleBarButtonsFullWeekFullYear; Rec.ShowExtraTitleBarButtons)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the extra toolbar buttons on the main title bars are visible (defaults to true).';
                }
            }
            group(TimeLine)
            {
                Visible = Rec.CalendarView = Rec.CalendarView::timeline;

                field(DefaultAxis; Rec.DefaultAxis)
                {
                    ApplicationArea = All;
                    ToolTip = 'States the default axis the view should use (defaults to “group”).';
                }
                field(MinutesBetweenSectionsTimeLine; Rec.MinutesBetweenSections)
                {
                    ApplicationArea = All;
                    ToolTip = 'States the number of minutes that should be used between rows in all views (defaults to 30).';
                }
                field(ShowExtraTitleBarButtonsFullWeekTimeLine; Rec.ShowExtraTitleBarButtons)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the extra toolbar buttons on the main title bars are visible (defaults to true).';
                }
            }
            group(AllEvents)
            {
                Visible = Rec.CalendarView = Rec.CalendarView::allEvents;

                field(ShowExtraTitleBarButtonsFullWeekAllEvents; Rec.ShowExtraTitleBarButtons)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the extra toolbar buttons on the main title bars are visible (defaults to true).';
                }
            }
        }
    }
}
