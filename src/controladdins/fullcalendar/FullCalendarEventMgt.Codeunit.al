
/// <summary>
/// Codeunit PTEFullCalendarEventMgt (ID 50102).
/// https://fullcalendar.io/docs/event-object
/// </summary>
codeunit 50202 PTEFullCalendarEventMgt
{
    var
        EventCollection: Dictionary of [Text, Text];
        CurrentEvent: JsonObject;
        IdToken: JsonToken;
        IdLbl: Label 'id';
        TitleLbl: Label 'title';
        EventConstraintLbl: Label 'constraint';
        EventOverLapLbl: Label 'overlap';
        EventAllowLbl: Label 'eventAllow';
        EventBackgroundColorLbl: Label 'backgroundColor';
        EventBorderColorLbl: Label 'borderColor';
        EventClassNamesLbl: Label 'classNames';
        EventGroupIdLbl: Label 'groupId';
        EventAllDayLbl: Label 'allDay';
        EventStartLbl: Label 'start';
        EventEndLbl: Label 'end';
        EventEditableLbl: Label 'editable';
        EventStartEditableLbl: Label 'startEditable';
        EventDurationEditableLbl: Label 'durationEditable';
        EventResourceEditableLbl: Label 'resourceEditable';
        EventResourceIdLbl: Label 'resourceId';
        InvalidIdErr: Label 'Invalid Id. Cannot be empty.';
        EventTextColorLbl: Label 'textColor';
        ExtendedPropsLbl: Label 'extendedProps';
        ToolTipLbl: Label 'tooltip';
        PostcodeLbl: Label 'postcode';
        EmptyTxt: Label '';


    /// <summary>
    /// ClearEvents.
    /// </summary>
    internal procedure ClearEvents()
    begin
        Clear(EventCollection);
    end;

    /// <summary>
    /// CreateEvent.
    /// </summary>
    /// <param name="Id">Text.</param>
    internal procedure CreateEvent(Id: Text)
    begin
        Clear(CurrentEvent);
        CurrentEvent.Add(IdLbl, Id);
    end;

    /// <summary>
    /// AddEventToCollection.
    /// Add current resource to the Events collection.
    /// </summary>
    internal procedure AddEventToCollection()
    begin
        AddEventToCollection(CurrentEvent);
    end;

    /// <summary>
    /// AddEventToCollection.
    /// Add or Replace current resource to the Events collection.
    /// </summary>
    /// <param name="EventToAdd">JsonObject.</param>
    internal procedure AddEventToCollection(EventToAdd: JsonObject)
    var
        EventText: Text;
    begin
        if not EventToAdd.Get(IdLbl, IdToken) then
            exit;

        EventToAdd.WriteTo(EventText);
        if EventCollection.ContainsKey(IdToken.AsValue().AsText()) then
            EventCollection.Remove(IdToken.AsValue().AsText());

        EventCollection.Add(IdToken.AsValue().AsText(), EventText);
    end;

    /// <summary>
    /// UpdateEventInCollection.
    /// </summary>
    /// <param name="EventToUpdate">JsonObject.</param>
    internal procedure UpdateEventInCollection(EventToUpdate: JsonObject)
    var
        EventText: Text;
    begin
        if not EventToUpdate.Get(IdLbl, IdToken) then
            exit;

        if not EventCollection.ContainsKey(IdToken.AsValue().AsText()) then begin
            AddEventToCollection(EventToUpdate);
            exit;
        end;

        EventToUpdate.WriteTo(EventText);
        EventCollection.Set(IdToken.AsValue().AsText(), EventText);
    end;

    /// <summary>
    /// DeleteEventFromCollection.
    /// </summary>
    /// <param name="Id">Text.</param>
    internal procedure DeleteEventFromCollection(Id: Text)
    begin
        if EventCollection.ContainsKey(Id) then
            EventCollection.Remove(Id);
    end;

    /// <summary>
    /// DeleteEventFromCollection.
    /// </summary>
    /// <param name="EventToDelete">JsonObject.</param>
    internal procedure DeleteEventFromCollection(EventToDelete: JsonObject)
    begin
        if EventToDelete.Get(IdLbl, IdToken) then
            if EventCollection.ContainsKey(IdToken.AsValue().AsText()) then
                EventCollection.Remove(IdToken.AsValue().AsText());
    end;

    /// <summary>
    /// GetEventFromCollection.
    /// </summary>
    /// <param name="Id">Text.</param>
    /// <returns>Return variable ReturnValue of type JsonObject.</returns>
    internal procedure GetEventFromCollection(Id: Text) ReturnValue: JsonObject
    var
        EventText: Text;
    begin
        if not EventCollection.Get(Id, EventText) then
            Error(InvalidIdErr);

        ReturnValue.ReadFrom(EventText);
    end;

    /// <summary>
    /// GetEvents.
    /// </summary>
    /// <returns>Return value of type JsonArray.</returns>
    internal procedure GetEvents() ReturnValue: JsonArray
    var
        EventObject: JsonObject;
        EventText: Text;
        Id: Text;
    begin
        foreach Id in EventCollection.Keys() do
            if EventCollection.Get(Id, EventText) then begin
                EventObject.ReadFrom(EventText);
                ReturnValue.Add(EventObject);
            end;
    end;

    /// <summary>
    /// GetCurrentEvent.
    /// </summary>
    /// <returns>Return value of type JsonObject.</returns>
    internal procedure GetCurrentEvent(): JsonObject
    begin
        exit(CurrentEvent);
    end;

    /// <summary>
    /// SetCurrentEvent.
    /// </summary>
    /// <param name="Id">Text.</param>
    /// <returns>Return value of type JsonObject.</returns>
    internal procedure SetCurrentEvent(Id: Text)
    var
        EventText: Text;
    begin
        if EventCollection.ContainsKey(Id) then begin
            EventCollection.Get(Id, EventText); //sets the current event.
            CurrentEvent.ReadFrom(EventText);
            exit;
        end;
        Error(InvalidIdErr);
    end;

    /// <summary>
    /// SetCurrentEvent.
    /// </summary>
    /// <param name="EventToSet">JsonObject.</param>
    internal procedure SetCurrentEvent(EventToSet: JsonObject)
    var
        EventString: Text;
        InvalidObjectErr: Label 'Invalid Event Object:\%1', Comment = '%1 = Object String';
    begin
        if not EventToSet.Get(IdLbl, IdToken) then
            Error(InvalidIdErr);

        EventToSet.WriteTo(EventString);
        if not CurrentEvent.ReadFrom(EventString) then
            Error(InvalidObjectErr, EventToSet.AsToken().AsValue().AsText());
    end;

    /// <summary>
    /// SetEventCollection.
    /// </summary>
    /// <param name="EventCollectionToSet">JsonArray.</param>
    internal procedure SetEventCollection(EventCollectionToSet: JsonArray)
    begin
        ClearEvents();
        AppendEventCollection(EventCollectionToSet);
    end;

    /// <summary>
    /// AppendEventCollection.
    /// </summary>
    /// <param name="EventCollectionToAppend">JsonArray.</param>
    internal procedure AppendEventCollection(EventCollectionToAppend: JsonArray)
    var
        EventToken: JsonToken;
        EventObject: JsonObject;
    begin
        foreach EventToken in EventCollectionToAppend do begin
            EventObject.ReadFrom(EventToken.AsValue().AsText());
            if EventObject.Get(IdLbl, IdToken) then
                EventCollection.Add(IdToken.AsValue().AsText(), EventToken.AsValue().AsText());
        end;
    end;

    /// <summary>
    /// SetId.
    /// Set the Event unique Id.
    /// </summary>
    /// <param name="Id">Text.</param>
    internal procedure SetId(Id: Text)
    begin
        if Id = EmptyTxt then
            Error(InvalidIdErr);

        UpdateValue(IdLbl, Id);
    end;

    /// <summary>
    /// SetTitle.
    /// Set the Event title (description).
    /// </summary>
    /// <param name="Title">Text.</param>
    internal procedure SetTitle(Title: Text)
    begin
        UpdateValue(TitleLbl, Title);
    end;

    /// <summary>
    /// SetAllDay.
    /// Determines if the event is shown in the “all-day” section of relevant views. In addition, if true the time text is not displayed with the event.
    /// </summary>
    /// <param name="AllDay">Boolean.</param>
    internal procedure SetAllDay(AllDay: Boolean)
    begin
        UpdateValue(EventAllDayLbl, AllDay);
    end;

    /// <summary>
    /// SetStartDateTime.
    /// Set the starting datetime for an event.
    /// </summary>
    /// <param name="StartDateTime">DateTime.</param>
    internal procedure SetStartDateTime(StartDateTime: DateTime)
    begin
        UpdateValue(EventStartLbl, StartDateTime);
    end;

    /// <summary>
    /// SetEndDateTime.
    /// Set the ending datetime for an event.
    /// </summary>
    /// <param name="EndDateTime">DateTime.</param>
    internal procedure SetEndDateTime(EndDateTime: DateTime)
    begin
        UpdateValue(EventEndLbl, EndDateTime);
    end;

    /// <summary>
    /// SetGroupId.
    /// Events that share a groupId will be dragged and resized together automatically.
    /// </summary>
    /// <param name="GroupId">Text.</param>
    internal procedure SetGroupId(GroupId: Text)
    begin
        UpdateValue(EventGroupIdLbl, GroupId);
    end;

    /// <summary>
    /// SetEditable.
    /// Determines whether the events on the calendar can be modified.
    /// </summary>
    /// <param name="Editable">Boolean.</param>
    internal procedure SetEditable(Editable: Boolean)
    begin
        UpdateValue(EventEditableLbl, Editable);
    end;

    /// <summary>
    /// SetStartEditable.
    /// Allow events’ start times to be editable through dragging.
    /// </summary>
    /// <param name="StartEditable">Boolean.</param>
    internal procedure SetStartEditable(StartEditable: Boolean)
    begin
        UpdateValue(EventStartEditableLbl, StartEditable);
    end;

    /// <summary>
    /// SetDurationEditable.
    /// Set whether we can edit the duration of the event, this is changing the time slot.
    /// </summary>
    /// <param name="DurationEditable">Boolean.</param>
    internal procedure SetDurationEditable(DurationEditable: Boolean)
    begin
        UpdateValue(EventDurationEditableLbl, DurationEditable);
    end;

    /// <summary>
    /// SetResourceEditable.
    /// Set whether we can edit the resource for this event, i.e. move it to another resource.
    /// </summary>
    /// <param name="ResourceEditable">Boolean.</param>
    internal procedure SetResourceEditable(ResourceEditable: Boolean)
    begin
        UpdateValue(EventResourceEditableLbl, ResourceEditable);
    end;

    /// <summary>
    /// SetResourceId.
    /// Set the resource Id for this event, used for grouping the events.
    /// </summary>
    /// <param name="ResourceId">Text.</param>
    internal procedure SetResourceId(ResourceId: Text)
    begin
        UpdateValue(EventResourceIdLbl, ResourceId);
    end;

    /// <summary>
    /// SetEventContstraint.
    /// Limits event dragging and resizing to certain windows of time.
    /// https://fullcalendar.io/docs/eventConstraint
    /// </summary>
    /// <param name="Constraint">JsonObject.</param>
    internal procedure SetEventConstraint(Constraint: JsonObject)
    begin
        UpdateValue(EventConstraintLbl, Constraint);
    end;

    /// <summary>
    /// SetEventOverLap.
    /// Determines if events being dragged and resized are allowed to overlap each other.
    /// https://fullcalendar.io/docs/eventOverlap
    /// </summary>
    /// <param name="EventOverlap">Boolean.</param>
    internal procedure SetEventOverLap(EventOverlap: Boolean)
    begin
        UpdateValue(EventOverlapLbl, EventOverlap);
    end;

    /// <summary>
    /// SetEventAllow.
    ///
    /// </summary>
    /// <param name="EventAllow">Boolean.</param>
    internal procedure SetEventAllow(EventAllow: Boolean)
    begin
        UpdateValue(EventAllowLbl, EventAllow);
    end;

    /// <summary>
    /// SetEventBackgroundColor.
    /// Set the background colour to be used for the event.
    /// </summary>
    /// <param name="EventBackgroundColor">Text.</param>
    internal procedure SetEventBackgroundColor(EventBackgroundColor: Text)
    begin
        UpdateValue(EventBackgroundColorLbl, EventBackgroundColor);
    end;

    /// <summary>
    /// SetEventBorderColor.
    /// Set the event border colour.
    /// </summary>
    /// <param name="EventBorderColor">Text.</param>
    internal procedure SetEventBorderColor(EventBorderColor: Text)
    begin
        UpdateValue(EventBorderColorLbl, EventBorderColor);
    end;


    /// <summary>
    /// SetEventTextColor.
    /// </summary>
    /// <param name="TextColor">Text.</param>
    internal procedure SetEventTextColor(TextColor: Text)
    begin
        UpdateValue(EventTextColorLbl, TextColor);
    end;

    /// <summary>
    /// SetEventClassNames.
    /// Set css classnames to use on event
    /// </summary>
    /// <param name="EventClassNames">Text.</param>
    internal procedure SetEventClassNames(EventClassNames: Text)
    begin
        UpdateValue(EventClassNamesLbl, EventClassNames);
    end;

    /// <summary>
    /// SetTooltipText.
    /// Set the tooltip text for the event.
    /// </summary>
    /// <param name="Tooltip">Text.</param>
    internal procedure SetTooltipText(Tooltip: Text)
    begin
        UpdateExtendedProps(ToolTipLbl, Tooltip);
    end;

    /// <summary>
    /// SetPostcode.
    /// </summary>
    /// <param name="Postcode">Text.</param>
    internal procedure SetPostcode(Postcode: Text)
    begin
        UpdateExtendedProps(PostcodeLbl, Postcode);
    end;

    /// <summary>
    /// UpdateValue.
    /// </summary>
    /// <param name="EventProperty">Text.</param>
    /// <param name="EventValue">Variant.</param>
    local procedure UpdateValue(EventProperty: Text; EventValue: Variant)
    var
        JsonHelper: Codeunit PTECalendarJsJsonHelper;
    begin
        JsonHelper.UpdateJsonObjectField(CurrentEvent, EventProperty, EventValue);
    end;

    /// <summary>
    /// UpdateExtendedProps.
    /// Update the extended properties.
    /// </summary>
    /// <param name="EventProperty">Text.</param>
    /// <param name="EventValue">Variant.</param>
    local procedure UpdateExtendedProps(EventProperty: Text; EventValue: Variant)
    var
        JsonHelper: Codeunit PTECalendarJsJsonHelper;
        ExtProps: JsonObject;
        JToken: JsonToken;
    begin
        if not CurrentEvent.Get(ExtendedPropsLbl, JToken) then
            CurrentEvent.Add(ExtendedPropsLbl, ExtProps)
        else
            ExtProps := JToken.AsObject();

        JsonHelper.UpdateJsonObjectField(ExtProps, EventProperty, EventValue);
        JsonHelper.UpdateJsonObjectField(CurrentEvent, ExtendedPropsLbl, ExtProps);
    end;
}