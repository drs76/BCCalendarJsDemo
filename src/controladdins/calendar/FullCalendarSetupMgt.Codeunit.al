/// <summary>
/// Codeunit PTEFullCalendarSetupMgt (ID 50104).
/// Holds setup for the FullCalendar
/// </summary>
codeunit 50104 PTEFullCalendarSetupMgt
{
    var
        CalendarSetup: JsonObject;
        MinTimeLbl: Label 'minTime';
        MaxTimeLbl: Label 'maxTime';
        NonWorkColorLbl: Label 'nonWorkColor';
        DragColorSettingsLbl: Label 'dragColorSettings';
        DragColorCheckByResourceIdLbl: Label 'dragByResourceId';
        SlotLabelFormatLbl: Label 'slotLabelFormat';
        DefaultFarColorLbl: Label 'defaultFarColor';
        DefaultCloseColorLbl: Label 'defaultCloseColor';
        DefaultAmberColorLbl: Label 'defaultAmberColor';
        TimeFormatLbl: Label 'timeFormat';
        SlotDurationMinutesLbl: Label 'slotDurationMinutes';
        SlotLabelIntervalMinutesLbl: Label 'slotLabelIntervalMinutes';
        DefaultViewLbl: Label 'defaultView';
        HeaderRightLbl: Label 'headerRight';
        ExternalEventsLbl: Label 'extEvents';
        ResourceHeightLbl: Label 'resourceHeight';
        MinMaxTimeFormatLbl: Label '<Hours24>:<Minutes,2>:<Seconds,2>';
        MinutesTxt: Label 'minutes';
        AllowedToAddEventsLbl: Label 'allowedToAddEvents';
        ResourceHeadingLbl: Label 'resourceHeading';
        DragEventTitleLbl: Label 'dragEventTitle';
        EditableLbl: Label 'editable';
        DroppableLbl: Label 'droppable';
        BusinessHoursLbl: Label 'businessHours';
        NavLinksLbl: Label 'navLinks';
        Enable2DayViewLbl: Label 'enable2DayView';
        ResourceAreaWidthLbl: Label 'resourceAreaWidth';
        DayOfMonthFormatLbl: Label 'dayOfMonthFormat';
        DefaultEventDurationLbl: Label 'defaultEventDurationLbl';
        SelectableLbl: Label 'selectable';
        AllDaySlotLbl: Label 'allDaySlot';
        EventsTextColorLbl: Label 'eventsTextColor';
        TooltipFontFamilyLbl: Label 'tooltipFontFamily';
        TooltipFontSizeLbl: Label 'tooltipFontSize';


    /// <summary>
    /// InitSetup.
    /// </summary>
    internal procedure InitSetup()
    begin
        Clear(CalendarSetup);
        ApplyDefaultSettings();
    end;

    /// <summary>
    /// GetCalendarSetup.
    /// </summary>
    /// <returns>Return value of type JsonObject.</returns>
    internal procedure GetCalendarSetup(): JsonObject
    begin
        exit(CalendarSetup);
    end;

    /// <summary>
    /// ApplyDefaultSettings.
    /// Add default settings to the setup.
    /// </summary>
    local procedure ApplyDefaultSettings()
    var
        JsonArr: JsonArray;
        NonWorkColourTxt: Label '969696';
        FarColourTxt: Label 'red';
        CloseColourTxt: Label 'green';
        AmberColourTxt: Label 'orange';
        DefaultViewTxt: Label 'resourceTimeGridDay';
        ResourceHeightTxt: Label 'auto';
        HeaderRightTxt: Label 'resourceTimeGridDay,resourceTimeGridWeek,dayGridMonth';
        ResourceHeaderTxt: Label 'Resources';
        ExternalEventsTxt: Label 'External Events';
        TimeFormatTxt: Label 'hh:mm';
        DayOfMonthFormatTxt: Label 'ddd DD/MM';
        ToolTipFontTxt: Label 'segoe-ui';
        DefaultEventDurationTxt: Label '01:00'; //1 hour
        EventTextColorTxt: Label '000000';
        ColourFormatTxt: Label '#%1', Comment = '%1 = Colour Code';
    begin
        SetMinTime(090000T);
        SetMaxTime(200000T);
        SetNonWorkingColour(NonWorkColourTxt);
        SetDefaultFarColour(StrSubStno(ColourFormatTxt, FarColourTxt));
        SetDefaultCloseColour(StrSubStno(ColourFormatTxt, CloseColourTxt));
        SetDefaultAmberColour(StrSubStno(ColourFormatTxt, AmberColourTxt));
        SetDefaultView(DefaultViewTxt);
        SetResourceHeight(ResourceHeightTxt);
        SetHeaderRight(HeaderRightTxt);
        SetResourceHeader(ResourceHeaderTxt);
        SetResourceAreaWidth(15);
        SetExternalHeader(ExternalEventsTxt);
        SetEditable(true);
        SetAllowedToAddEvents(true);
        SetDroppable(true);
        SetSelectable(true);
        SetNavLinks(true);
        SetEnable2GridView(false);
        SetTimeFormat(TimeFormatTxt);
        SetDayOfMonthFormat(DayOfMonthFormatTxt);
        SetDefaultEventDuration(DefaultEventDurationTxt);
        SetEventsTextColor(StrSubStno(ColourFormatTxt, EventTextColorTxt));
        SetTooltipFontFamily(ToolTipFontTxt);
        SetTooltipFontSize(12);
        SetSlotDurationMinutes(30);
        SetSlotIntervalLabelMinutes(60);
        SetExternalEvents(JsonArr);
        SetDragColorSettings(JsonArr);
    end;

    /// <summary>
    /// SetEventsTextColor.
    /// Text colour to use for events.
    /// </summary>
    /// <param name="Colour">Text.</param>
    internal procedure SetEventsTextColor(Colour: Text)
    begin
        UpdateValue(EventsTextColorLbl, Colour);
    end;

    /// <summary>
    /// SetTooltipFontFamily.
    /// </summary>
    /// <param name="FontFamily">Text.</param>
    internal procedure SetTooltipFontFamily(FontFamily: Text)
    begin
        UpdateValue(TooltipFontFamilyLbl, FontFamily);
    end;

    /// <summary>
    /// SetTooltipFontSize.
    /// </summary>
    /// <param name="FontSize">Integer.</param>
    internal procedure SetTooltipFontSize(FontSize: Integer)
    begin
        UpdateValue(TooltipFontSizeLbl, FontSize);
    end;

    /// <summary>
    /// SetSelectable.
    /// Default: true
    /// </summary>
    /// <param name="Selectable">Boolean.</param>
    internal procedure SetSelectable(Selectable: Boolean)
    begin
        UpdateValue(SelectableLbl, Selectable);
    end;

    /// <summary>
    /// SetDefaultEventDuration.
    /// </summary>
    /// <param name="EventDuration">Text.</param>
    internal procedure SetDefaultEventDuration(EventDuration: Text)
    begin
        UpdateValue(DefaultEventDurationLbl, EventDuration);
    end;

    /// <summary>
    /// SetMinTime.
    /// Default: 09:00:00
    /// </summary>
    /// <param name="MinTimeToSet">Time.</param>
    internal procedure SetMinTime(MinTimeToSet: Time)
    begin
        UpdateValue(MinTimeLbl, Format(MinTimeToSet, 0, MinMaxTimeFormatLbl));
    end;

    /// <summary>
    /// SetMaxTime.
    /// Default: 20:00:00
    /// </summary>
    /// <param name="MaxTimeToSet">Time.</param>
    internal procedure SetMaxTime(MaxTimeToSet: Time)
    begin
        UpdateValue(MaxTimeLbl, Format(MaxTimeToSet, 0, MinMaxTimeFormatLbl));
    end;

    /// <summary>
    /// SetNonWorkingColour.
    /// Default: #969696
    /// </summary>
    /// <param name="NonWorkingColour">Text.</param>
    internal procedure SetNonWorkingColour(NonWorkingColour: Text)
    begin
        UpdateValue(NonWorkColorLbl, NonWorkingColour);
    end;

    /// <summary>
    /// SetDefaultFarColour.
    /// Default: red
    /// </summary>
    /// <param name="FarColourToSet">Text.</param>
    internal procedure SetDefaultFarColour(FarColourToSet: Text)
    begin
        UpdateValue(DefaultFarColorLbl, FarColourToSet);
    end;

    /// <summary>
    /// SetDefaultCloseColour.
    /// Default: green
    /// </summary>
    /// <param name="CloseColourToSet">Text.</param>
    internal procedure SetDefaultCloseColour(CloseColourToSet: Text)
    begin
        UpdateValue(DefaultCloseColorLbl, CloseColourToSet);
    end;

    /// <summary>
    /// SetDefaultAmberColour.
    /// </summary>
    /// <param name="AmberColourToSet">Text.</param>
    internal procedure SetDefaultAmberColour(AmberColourToSet: Text)
    begin
        UpdateValue(DefaultAmberColorLbl, AmberColourToSet);
    end;

    /// <summary>
    /// SetDefaultView.
    /// Default: resourceTimeGridDay
    /// </summary>
    /// <param name="DefaultViewToSet">Text.</param>
    internal procedure SetDefaultView(DefaultViewToSet: Text)
    begin
        UpdateValue(DefaultViewLbl, DefaultViewToSet);
    end;

    /// <summary>
    /// SetResourceHeight.
    /// Default: auto
    /// </summary>
    /// <param name="ResourceHeightToSet">Text.</param>
    internal procedure SetResourceHeight(ResourceHeightToSet: Text)
    begin
        UpdateValue(ResourceHeightLbl, ResourceHeightToSet);
    end;

    /// <summary>
    /// SetResourceAreaWidth.
    /// Default: 15%
    /// Set the resource area width percent.
    /// </summary>
    /// <param name="ResourceAreadWidth">Integer.</param>
    internal procedure SetResourceAreaWidth(ResourceAreadWidth: Integer)
    var
        ResourceWidthTxt: Label '%1%', Comment = 'Width';
    begin
        UpdateValue(ResourceAreaWidthLbl, StrSubstNo(ResourceWidthTxt, ResourceAreadWidth));
    end;

    /// <summary>
    /// SetHeaderRight.
    /// Default: resourceTimeGridDay,resourceTimeGridWeek,dayGridMonth
    /// </summary>
    /// <param name="HeaderRightToSet">Text.</param>
    internal procedure SetHeaderRight(HeaderRightToSet: Text)
    begin
        UpdateValue(HeaderRightLbl, HeaderRightToSet);
    end;

    /// <summary>
    /// SetSlotDurationMinutes.
    /// Default: 30
    /// </summary>
    /// <param name="MinutesToSet">Integer.</param>
    internal procedure SetSlotDurationMinutes(MinutesToSet: Integer)
    var
        SlotFormatTxt: Label '00:%1:00', Comment = '%1 = Minutes';
    begin
        UpdateValue(SlotDurationMinutesLbl, StrSubStno(SlotFormatTxt, MinutesToSet));
    end;

    /// <summary>
    /// SetSlotIntervalLabelMinutes.
    /// Default: 30
    /// </summary>
    /// <param name="MinutesToSet">Integer.</param>
    internal procedure SetSlotIntervalLabelMinutes(MinutesToSet: Integer)
    var
        SlotDuration: JsonObject;
    begin
        SlotDuration.Add(MinutesTxt, MinutesToSet);
        UpdateValue(SlotLabelIntervalMinutesLbl, SlotDuration);
    end;

    /// <summary>
    /// SetExternalEvents.
    /// Add External event source.
    /// </summary>
    /// <param name="ExtEventsToSet">JsonArray.</param>
    internal procedure SetExternalEvents(ExtEventsToSet: JsonArray)
    begin
        UpdateValue(ExternalEventsLbl, ExtEventsToSet);
    end;

    /// <summary>
    /// SetSlotLabelFormat.
    /// </summary>
    /// <param name="SlotLabelFormat">Text.</param>
    internal procedure SetSlotLabelFormat(SlotLabelFormat: Text)
    begin
        UpdateValue(SlotLabelFormatLbl, SlotLabelFormat);
    end;

    /// <summary>
    /// SetTimeFormat.
    /// Default: 'hh:mm'
    /// </summary>
    /// <param name="TimeFormat">Text.</param>
    internal procedure SetTimeFormat(TimeFormat: Text)
    begin
        UpdateValue(TimeFormatLbl, TimeFormat);
    end;

    /// <summary>
    /// SetDayOfMonthFormat.
    /// </summary>
    /// <param name="DayOfMonthFormat">Text.</param>
    internal procedure SetDayOfMonthFormat(DayOfMonthFormat: Text)
    begin
        UpdateValue(DayOfMonthFormatLbl, DayOfMonthFormat);
    end;

    /// <summary>
    /// SetDragColorSettings.
    /// </summary>
    /// <param name="DragColorSettings">JsonArray.</param>
    internal procedure SetDragColorSettings(DragColorSettings: JsonArray)
    begin
        UpdateValue(DragColorSettingsLbl, DragColorSettings);
    end;

    /// <summary>
    /// SetDragColorCheckByResourceId.
    /// Determine if Near/Far check is filtered by Resource Id.
    /// </summary>
    /// <param name="DragColorCheckByResourceId">Boolean.</param>
    internal procedure SetDragColorCheckByResourceId(DragColorCheckByResourceId: Boolean)
    begin
        UpdateValue(DragColorCheckByResourceIdLbl, DragColorCheckByResourceId);
    end;

    /// <summary>
    /// SetAllowedToAddEvents.
    /// Default: true
    /// </summary>
    /// <param name="AllowedToAddEvents">Boolean.</param>
    internal procedure SetAllowedToAddEvents(AllowedToAddEvents: Boolean)
    begin
        UpdateValue(AllowedToAddEventsLbl, AllowedToAddEvents);
    end;

    /// <summary>
    /// SetResourceHeader.
    /// </summary>
    /// <param name="ResourceHeader">Text.</param>
    internal procedure SetResourceHeader(ResourceHeader: Text)
    begin
        UpdateValue(ResourceHeadingLbl, ResourceHeader);
    end;

    /// <summary>
    /// SetExternalHeader.
    /// </summary>
    /// <param name="ExternalHeader">Text.</param>
    internal procedure SetExternalHeader(ExternalHeader: Text)
    begin
        UpdateValue(DragEventTitleLbl, ExternalHeader);
    end;

    /// <summary>
    /// SetEditable.
    /// All to edit events on grid.
    /// Default: true
    /// </summary>
    /// <param name="editable">Boolean.</param>
    internal procedure SetEditable(editable: Boolean)
    begin
        UpdateValue(EditableLbl, editable);
    end;

    /// <summary>
    /// SetDroppable.
    /// </summary>
    /// <param name="droppable">Boolean.</param>
    internal procedure SetDroppable(droppable: Boolean)
    begin
        UpdateValue(DroppableLbl, droppable);
    end;

    /// <summary>
    /// SetBusinessHours.
    /// </summary>
    /// <param name="businessHours">JsonObject.</param>
    internal procedure SetBusinessHours(businessHours: JsonObject)
    begin
        UpdateValue(BusinessHoursLbl, businessHours)
    end;

    /// <summary>
    /// SetNavLinks.
    /// </summary>
    /// <param name="navLinks">Boolean.</param>
    internal procedure SetNavLinks(navLinks: Boolean)
    begin
        UpdateValue(NavLinksLbl, navLinks);
    end;

    /// <summary>
    /// SetEnable2GridView.
    /// Show the bespoke 2 Day Grid view.
    /// </summary>
    /// <param name="Enabled">Boolean.</param>
    internal procedure SetEnable2GridView(Enabled: Boolean)
    begin
        UpdateValue(Enable2DayViewLbl, Enabled);
    end;

    /// <summary>
    /// SetAllDaySlot.
    /// Show the all day slot on time views.
    /// </summary>
    /// <param name="ShowAllDay">Boolean.</param>
    internal procedure SetAllDaySlot(ShowAllDay: Boolean)
    begin
        UpdateValue(AllDaySlotLbl, ShowAllDay);
    end;

    /// <summary>
    /// UpdateValue.
    /// </summary>
    /// <param name="SetupProperty">Text.</param>
    /// <param name="SetupValue">Variant.</param>
    local procedure UpdateValue(SetupProperty: Text; SetupValue: Variant)
    var
        JsonHelper: Codeunit PTEJsonHelper;
    begin
        JsonHelper.UpdateJsonObjectField(CalendarSetup, SetupProperty, SetupValue);
    end;
}
