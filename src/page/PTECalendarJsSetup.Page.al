page 50204 PTECalendarJsSetup
{
    ApplicationArea = All;
    Caption = 'CalendarJs Setup';
    PageType = Card;
    UsageCategory = None;
    SourceTable = PTECalendarJsSetup;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(CalendarCode; Rec.CalendarCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calendar Code.';
                    Importance = Promoted;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description for the calendar setup.';
                    Importance = Promoted;
                }
                field(Default; Rec.Default)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable to set this as the default calendar setup.';
                }
            }

            group(Options)
            {
                field(ManualEditingEnabled; Rec.ManualEditingEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if adding, editing, dragging and removing events is enabled (defaults to true).';
                }
                field(AutoRefreshTimerDelay; Rec.AutoRefreshTimerDelay)
                {
                    ApplicationArea = All;
                    ToolTip = 'The amount of time to wait before each full refresh (defaults to 30000 milliseconds, 0 disables it).';
                }
                field(FullScreenModeEnabled; Rec.FullScreenModeEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if double click on the main title bar activates full-screen mode (defaults to true).';
                }
                field(IsWidget; Rec.IsWidget)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the new calendar instance is only a widget (defaults to false).';
                }
                field(ViewToOpenOnFirstLoad; Rec.ViewToOpenOnFirstLoad)
                {
                    ApplicationArea = All;
                    ToolTip = 'States which view should be opened when the Calendar is first initialized (defaults to null, accepts “full-day”, “full-week”, “full-year”, “timeline”, and “all-events”).';
                }
                field(Spacing; Rec.Spacing)
                {
                    ApplicationArea = All;
                    ToolTip = 'States the default spacing that should be used for additional margins (defaults to 10).';
                }
                field(TooltipsEnabled; Rec.TooltipsEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'tooltipsEnabled 	States if the tooltips are enabled throughout all the displays (defaults to true).';
                }
                field(TooltipDelay; Rec.TooltipDelay)
                {
                    ApplicationArea = All;
                    ToolTip = 'The amount of time to wait until a tooltip is shown (defaults to 1000 milliseconds).';
                    Enabled = Rec.TooltipsEnabled;
                }
                field(UrlWindowTarget; Rec.UrlWindowTarget)
                {
                    ApplicationArea = All;
                    ToolTip = 'States the target that an event URL should be opened in (defaults to _blank for a new window).';
                }
                field(OpenInFullScreenMode; Rec.OpenInFullScreenMode)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if full-screen mode should be turned on when the calendar is rendered (defaults to false).';
                }
                field(UseEscapeKeyToExitFullScreen; Rec.UseEscapeKeyToExitFullScreen)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the escape key should exit full-screen mode (if enabled, defaults to true).';
                }
                field(AllowHtmlInDisplay; Rec.AllowHtmlInDisplay)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if HTML can be used in the display (defaults to false).';
                }
                field(ConfigurationDialogEnabled; Rec.ConfigurationDialogEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the configuration dialog is enabled (defaults to true).';
                }
                field(PopUpNotificationsEnabled; Rec.PopUpNotificationsEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the popup notifications (when actions are performed) are enabled (defaults to true).';
                }
                field(ShortcutKeysEnabled; Rec.ShortcutKeysEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the shortcut keys are enabled (defaults to true).';
                }
                field(EventColorsEditingEnabled; Rec.EventColorsEditingEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if changing the colors for events in the “Edit Event” dialog is enabled (defaults to true).';
                }
            }

            group(DateConfiguration)
            {
                Caption = 'Date Configuration';

                field(ShowHolidays; Rec.ShowHolidays)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the holidays should be shown (defaults to true).';
                }
                field(ShowDayNumberOrdinals; Rec.ShowDayNumberOrdinals)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the day ordinal values should be shown (defaults to true).';
                }
                field(Holidays; HolidaysText)
                {
                    ApplicationArea = All;
                    Caption = 'Holidays';
                    ToolTip = 'The holidays that should be shown for specific days/months (refer to “Holiday” documentation for properties).';
                }
                field(VisibleDays; Rec.VisibleDays)
                {
                    ApplicationArea = All;
                    ToolTip = 'States the day numbers that should be visible (Outside listing all events. Defaults to [ 0, 1, 2, 3, 4, 5, 6 ], Mon=0, Sun=6).';

                    trigger OnAssistEdit()
                    var
                        SelectFromEnum: Page PTESelectFromEnumValues;
                    begin
                        SelectFromEnum.SetForDaysOfWeek(Rec.VisibleDays);
                        Rec.AssistForDaysOfWeek(SelectFromEnum, Rec.VisibleDays);
                    end;
                }
                field(WeekendDays; Rec.WeekendDays)
                {
                    ApplicationArea = All;
                    ToolTip = 'States the day numbers that that are considered weekend days (defaults to [ 0, 1, 2, 3, 4, 5, 6 ], Mon=0, Sun=6).';

                    trigger OnAssistEdit()
                    var
                        SelectFromEnum: Page PTESelectFromEnumValues;
                    begin
                        SelectFromEnum.SetForDaysOfWeek(Rec.WeekendDays);
                        Rec.AssistForDaysOfWeek(SelectFromEnum, Rec.WeekendDays);
                    end;
                }
                field(WorkingDays; Rec.WorkingDays)
                {
                    ApplicationArea = All;
                    ToolTip = 'States the day numbers that that are considered working days (defaults to [ 0, 1, 2, 3, 4, 5, 6 ], Mon=0, Sun=6).';

                    trigger OnAssistEdit()
                    var
                        SelectFromEnum: Page PTESelectFromEnumValues;
                    begin
                        SelectFromEnum.SetForDaysOfWeek(Rec.WorkingDays);
                        Rec.AssistForDaysOfWeek(SelectFromEnum, Rec.WorkingDays);
                    end;
                }
                field(MinimumYear; Rec.MinimumYear)
                {
                    ApplicationArea = All;
                    ToolTip = 'The minimum year that can be shown in the Calendar (defaults to 1900).';
                }
                field(MaximumYear; Rec.MaximumYear)
                {
                    ApplicationArea = All;
                    ToolTip = 'The maximum year that can be shown in the Calendar (defaults to 2099).';
                }
                field(StartOfWeekDay; Rec.StartOfWeekDay)
                {
                    ApplicationArea = All;
                    ToolTip = 'States what day the week starts on (defaults to 0, with options: Mon = 0, Sat = 5, Sun = 6).';
                }
                field(WorkingHoursStart; WorkingHrsStartText)
                {
                    ApplicationArea = All;
                    Caption = 'WorkingHoursStart';
                    ToolTip = 'States when the time the working hours start (for example, “09:00”, or { 2: “09:00” } for specific days, and defaults to null).';
                }
                field(WorkingHoursEnd; WorkingHrsEndText)
                {
                    ApplicationArea = All;
                    Caption = 'WorkingHoursEnd';
                    ToolTip = 'States when the time the working hours end (for example, “17:00”, or { 2: “17:00” } for specific days, and defaults to null).';
                }
                field(ReverseOrderDaysOfWeek; Rec.ReverseOrderDaysOfWeek)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the days of the week should be reversed (for Hebrew calendars, for example. Defaults to false).';
                }
                field(UseAmPmForTimeDisplays; Rec.UseAmPmForTimeDisplays)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the AM/PM time format should be used for all time displays (defaults to false).';
                }
            }

            group(Organiser)
            {
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
            }

            group(Events)
            {
                field(ImportEventsEnabled; Rec.ImportEventsEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if importing events is enabled (defaults to true).';
                }
                field(ExportEventsEnabled; Rec.ExportEventsEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if exporting events is enabled (defaults to true).';
                }
                field(DragAndDropForEventsEnabled; Rec.DragAndDropForEventsEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if dragging and dropping events around the days of the month is enabled (defaults to true).';
                }
                field(EventNotificationsEnabled; Rec.EventNotificationsEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if notifications should be shown for events (defaults to false).';
                }
                field(HideEventsWithoutGroupAssigned; Rec.HideEventsWithoutGroupAssigned)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if events without a group should be hidden (defaults to false).';
                }
                field(UseTemplateWhenAddingNewEvent; Rec.UseTemplateWhenAddingNewEvent)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if a blank template event should be added when adding a new event (causing the dialog to be in edit mode, defaults to true).';
                }
                group(Defaults)
                {
                    field(DefaultEventDuration; Rec.DefaultEventDuration)
                    {
                        ApplicationArea = All;
                        ToolTip = 'States the default duration used when a new event is added (defaults to 30 minutes).';
                    }
                    field(DefaultEventBackgroundColor; Rec.DefaultEventBackgroundColor)
                    {
                        ApplicationArea = All;
                        ToolTip = 'States the default background color that should be used for events (defaults to “#484848”).';
                    }
                    usercontrol(DefaultEventBackGroundColorPicker; PTEColorPickerControl)
                    {
                        ApplicationArea = All;
                        trigger ControlReady()
                        begin
                            CurrPage.DefaultEventBackGroundColorPicker.Init();
                        end;
                    }
                    field(DefaultEventTextColor; Rec.DefaultEventTextColor)
                    {
                        ApplicationArea = All;
                        ToolTip = 'States the default text color that should be used for events (defaults to “#F5F5F5”).';
                    }
                    usercontrol(DefaultEventTextColorPicker; PTEColorPickerControl)
                    {
                        ApplicationArea = All;
                        trigger ControlReady()
                        begin
                            CurrPage.DefaultEventTextColorPicker.Init();
                        end;
                    }
                    field(DefaultEventBorderColor; Rec.DefaultEventBorderColor)
                    {
                        ApplicationArea = All;
                        ToolTip = 'States the default border color that should be used for events (defaults to “#282828”).';
                    }
                    usercontrol(DefaultEventBorderColorPicker; PTEColorPickerControl)
                    {
                        ApplicationArea = All;
                        trigger ControlReady()
                        begin
                            CurrPage.DefaultEventBorderColorPicker.Init();
                        end;
                    }
                }
                group(Limits)
                {
                    field(MaximumEventTitleLength; Rec.MaximumEventTitleLength)
                    {
                        ApplicationArea = All;
                        ToolTip = 'States the maximum length allowed for an event title (defaults to 0 to allow any size).';
                    }
                    field(MaximumEventDescriptionLength; Rec.MaximumEventDescriptionLength)
                    {
                        ApplicationArea = All;
                        ToolTip = 'States the maximum length allowed for an event description (defaults to 0 to allow any size).';
                    }
                    field(MaximumEventLocationLength; Rec.MaximumEventLocationLength)
                    {
                        ApplicationArea = All;
                        ToolTip = 'States the maximum length allowed for an event location (defaults to 0 to allow any size).';
                    }
                    field(MaximumEventGroupLength; Rec.MaximumEventGroupLength)
                    {
                        ApplicationArea = All;
                        ToolTip = 'States the maximum length allowed for an event group (defaults to 0 to allow any size).';
                    }
                }
            }

            group(SideMenu)
            {
                field(SideMenuShowDays; Rec.SideMenuShowDays)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the “Days” section on the Side Menu is visible (defaults to true).';
                }
                field(SideMenuShowGroups; Rec.SideMenuShowGroups)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the “Groups” section on the Side Menu is visible (defaults to true).';
                }
                field(SideMenuShowEventTypes; Rec.SideMenuShowEventTypes)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the “Event Types” section on the Side Menu is visible (defaults to true).';
                }
                field(SideMenuShowWorkingDays; Rec.SideMenuShowWorkingDays)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the “Working Days” section on the Side Menu is visible (defaults to true).';
                }
                field(SideMenuDhowWeekendDays; Rec.SideMenuShowWeekendDays)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the “Weekend Days” section on the Side Menu is visible (defaults to true).';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewOptions)
            {
                ApplicationArea = All;
                Caption = 'View Options';
                ToolTip = 'Set the options for the diferent views for this Calendar Setup.';
                Image = ViewServiceOrder;
                Enabled = (Rec.CalendarCode <> '');

                RunObject = page PTECalendarJSViewOptions;
                RunPageLink = CalendarCode = field(CalendarCode);
            }
            action(SearchOptions)
            {
                ApplicationArea = All;
                Caption = 'Search Options';
                ToolTip = 'Set the search options for this Calendar Setup.';
                Image = Find;
                Enabled = (Rec.CalendarCode <> '');

                RunObject = page PTECalendarJsSearchOptions;
                RunPageLink = CalendarCode = field(CalendarCode);
            }
            action(Translations)
            {
                ApplicationArea = All;
                Caption = 'Translations';
                ToolTip = 'Maintain Caption Translations for this Calendar Setup.';
                Image = Language;
                Enabled = (Rec.CalendarCode <> '');

                RunObject = page PTECalendarJsTranslatons;
                RunPageLink = CalendarCode = field(CalendarCode);
            }
        }
        area(Promoted)
        {
            actionref(ViewOptionsPromoted; ViewOptions)
            {
            }
            actionref(SearchOptionsPromted; SearchOptions)
            {
            }
            actionref(TranslationsPromoted; Translations)
            {
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetFields();
    end;

    var
        HolidaysText: Text;
        WorkingHrsStartText: Text;
        WorkingHrsEndText: Text;


    local procedure SetFields()
    begin
        CurrPage.DefaultEventBackGroundColorPicker.SetColour(Rec.DefaultEventBackgroundColor);
        CurrPage.DefaultEventBorderColorPicker.SetColour(Rec.DefaultEventBorderColor);
        CurrPage.DefaultEventTextColorPicker.SetColour(Rec.DefaultEventTextColor);
    end;
}
