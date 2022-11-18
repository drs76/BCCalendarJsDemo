
/// <summary>
/// Codeunit PTEFullCalendarResourceMgt (ID 50100).
/// Wrapper for FullCalendar Resources
/// </summary>
codeunit 50100 PTEFullCalendarResourceMgt
{
    var
        ResourceCollection: Dictionary of [Text, Text];
        CurrentResource: JsonObject;
        IdToken: JsonToken;
        ResourceText: Text;
        IdLbl: Label 'id';
        TitleLbl: Label 'title';
        BackgroundColorLbl: Label 'backgroundColor';
        EventConstraintLbl: Label 'businessHours';
        EventOverLapLbl: Label 'eventOverlap';
        EventAllowLbl: Label 'eventAllow';
        EventBackgroundColorLbl: Label 'eventBackgroundColor';
        EventBorderColorLbl: Label 'eventBorderColor';
        EventTextColorLbl: Label 'eventTextColor';
        EventClassNamesLbl: Label 'eventClassNames';
        InvalidIdErr: label 'Invalid Id.';
        ExtendedPropsLbl: Label 'extendedProps';
        ToolTipLbl: Label 'tooltip';
        EmptyTxt: Label '';


    /// <summary>
    /// ClearResources.
    /// </summary>
    internal procedure ClearResources()
    begin
        Clear(ResourceCollection);
    end;

    /// <summary>
    /// CreateResource.
    /// </summary>
    /// <param name="Id">Text.</param>
    internal procedure CreateResource(Id: Text)
    begin
        if Id = EmptyTxt then
            Error(InvalidIdErr);

        Clear(CurrentResource);
        CurrentResource.Add(IdLbl, Id);
    end;

    /// <summary>
    /// AddResouceToCollection.
    /// Add current resource to the Resources collection.
    /// </summary>
    internal procedure AddResourceToCollection()
    begin
        AddResourceToCollection(CurrentResource);
    end;

    /// <summary>
    /// AddResouceToCollection.
    /// Add current resource to the Resources collection.
    /// </summary>
    /// <param name="ResourceToAdd">JsonObject.</param>
    internal procedure AddResourceToCollection(ResourceToAdd: JsonObject)
    begin
        if not ResourceToAdd.Get(IdLbl, IdToken) then
            Error(InvalidIdErr);

        ResourceToAdd.WriteTo(ResourceText);
        if ResourceCollection.ContainsKey(IdToken.AsValue().AsText()) then
            ResourceCollection.Set(IdToken.AsValue().AsText(), ResourceText)
        else
            ResourceCollection.Add(IdToken.AsValue().AsText(), ResourceText);
    end;

    /// <summary>
    /// UpdateResourceInCollection.
    /// </summary>
    /// <param name="ResourceToUpdate">JsonObject.</param>
    internal procedure UpdateResourceInCollection(ResourceToUpdate: JsonObject)
    begin
        if not ResourceToUpdate.Get(IdLbl, IdToken) then
            exit;

        ResourceToUpdate.WriteTo(ResourceText);
        if ResourceCollection.ContainsKey(IdToken.AsValue().AsText()) then
            ResourceCollection.Set(IdToken.AsValue().AsText(), ResourceText);
    end;

    /// <summary>
    /// DeleteResourceFromCollection.
    /// </summary>
    /// <param name="Id">Text.</param>
    internal procedure DeleteResourceFromCollection(Id: Text)
    begin
        if ResourceCollection.ContainsKey(Id) then
            ResourceCollection.Remove(Id);
    end;

    /// <summary>
    /// DeleteResourceFromCollection.
    /// </summary>
    /// <param name="ResourceToDelete">JsonObject.</param>
    internal procedure DeleteResourceFromCollection(ResourceToDelete: JsonObject)
    begin
        if ResourceToDelete.Get(IdLbl, IdToken) then
            if ResourceCollection.ContainsKey(IdToken.AsValue().AsText()) then
                ResourceCollection.Remove(IdToken.AsValue().AsText());
    end;

    /// <summary>
    /// GetResourceFromCollection.
    /// </summary>
    /// <param name="Id">Text.</param>
    /// <returns>Return variable ReturnValue of type JsonObject.</returns>
    internal procedure GetEventFromCollection(Id: Text) ReturnValue: JsonObject
    begin
        if not ResourceCollection.Get(Id, ResourceText) then
            Error(InvalidIdErr);

        ReturnValue.ReadFrom(ResourceText);
    end;

    /// <summary>
    /// GetCurrentResource.
    /// </summary>
    /// <returns>Return value of type JsonObject.</returns>
    internal procedure GetResources() ReturnValue: JsonArray
    var
        Id: Text;
        ResourceObject: JsonObject;
    begin
        foreach Id in ResourceCollection.Keys() do
            if ResourceCollection.Get(Id, ResourceText) then begin
                ResourceObject.ReadFrom(ResourceText);
                ReturnValue.Add(ResourceObject);
            end;
    end;

    /// <summary>
    /// GetCurrentResource.
    /// </summary>
    /// <returns>Return value of type JsonObject.</returns>
    internal procedure GetCurrentResource(): JsonObject
    begin
        exit(CurrentResource);
    end;

    /// <summary>
    /// SetResourceCollection.
    /// </summary>
    /// <param name="ResourceCollectionToSet">JsonArray.</param>
    internal procedure SetResourceCollection(ResourceCollectionToSet: JsonArray)
    begin
        ClearResources();
        AppendEventCollection(ResourceCollectionToSet);
    end;

    /// <summary>
    /// AppendResourceCollection.
    /// </summary>
    /// <param name="ResourceCollectionToAppend">JsonArray.</param>
    internal procedure AppendEventCollection(ResourceCollectionToAppend: JsonArray)
    var
        EventToken: JsonToken;
        EventObject: JsonObject;
    begin
        foreach EventToken in ResourceCollectionToAppend do begin
            EventObject.ReadFrom(EventToken.AsValue().AsText());
            if EventObject.Get(IdLbl, IdToken) then begin
                EventObject.WriteTo(ResourceText);
                ResourceCollection.Add(IdToken.AsValue().AsText(), ResourceText);
            end;
        end;
    end;

    /// <summary>
    /// SetCurrentResource.
    /// </summary>
    /// <param name="Id">Text.</param>
    /// <returns>Return value of type JsonObject.</returns>
    internal procedure SetCurrentResource(Id: Text)
    begin
        if not ResourceCollection.Get(Id, ResourceText) then
            Error(InvalidIdErr);

        CurrentResource.ReadFrom(ResourceText);
    end;

    /// <summary>
    /// SetCurrentResource.
    /// </summary>
    /// <param name="ResourceToSet">JsonObject.</param>
    internal procedure SetCurrentResource(ResourceToSet: JsonObject)
    var
        InvalidObjectErr: Label 'Invalid Event Object:\%1', Comment = '%1 = Object String';
    begin
        if not ResourceToSet.Get(IdLbl, IdToken) then
            Error(InvalidIdErr);

        if not CurrentResource.ReadFrom(ResourceToSet.AsToken().AsValue().AsText()) then
            Error(InvalidObjectErr, ResourceToSet.AsToken().AsValue().AsText());
    end;

    /// <summary>
    /// SetId.
    /// </summary>
    /// <param name="Id">Text.</param>
    internal procedure SetId(Id: Text)
    begin
        UpdateValue(IdLbl, Id);
    end;

    /// <summary>
    /// SetTitle.
    /// </summary>
    /// <param name="Title">Text.</param>
    internal procedure SetTitle(Title: Text)
    begin
        UpdateValue(TitleLbl, Title);
    end;

    /// <summary>
    /// SetBackgroundColour.
    /// </summary>
    /// <param name="Color">Text.</param>
    internal procedure SetBackgroundColour(Color: Text)
    begin
        UpdateValue(BackgroundColorLbl, Color);
    end;

    /// <summary>
    /// SetEventContstraint.
    /// </summary>
    /// <param name="Constraint">JsonObject.</param>
    internal procedure SetEventContstraint(Constraint: JsonObject)
    begin
        UpdateValue(EventConstraintLbl, Constraint);
    end;

    /// <summary>
    /// SetEventOverLap.
    /// </summary>
    /// <param name="EventOverlap">Boolean.</param>
    internal procedure SetEventOverLap(EventOverlap: Boolean)
    begin
        UpdateValue(EventOverlapLbl, EventOverlap);
    end;

    /// <summary>
    /// SetEventAllow.
    /// </summary>
    /// <param name="EventAllow">Boolean.</param>
    internal procedure SetEventAllow(EventAllow: Boolean)
    begin
        UpdateValue(EventAllowLbl, EventAllow);
    end;

    /// <summary>
    /// SetEventBackgroundColor.
    /// </summary>
    /// <param name="EventBackgroundColor">Text.</param>
    internal procedure SetEventBackgroundColor(EventBackgroundColor: Text)
    begin
        UpdateValue(EventBackgroundColorLbl, EventBackgroundColor);
    end;

    /// <summary>
    /// SetEventBorderColor.
    /// </summary>
    /// <param name="EventBorderColor">Text.</param>
    internal procedure SetEventBorderColor(EventBorderColor: Text)
    begin
        UpdateValue(EventBorderColorLbl, EventBorderColor);
    end;

    /// <summary>
    /// SetEventTextColor.
    /// </summary>
    /// <param name="EventTextColor">Text.</param>
    internal procedure SetEventTextColor(EventTextColor: Text)
    begin
        UpdateValue(EventTextColorLbl, EventTextColor);
    end;

    /// <summary>
    /// SetEventClassNames.
    /// </summary>
    /// <param name="EventClassNames">Text.</param>
    internal procedure SetEventClassNames(EventClassNames: Text)
    begin
        UpdateValue(EventClassNamesLbl, EventClassNames);
    end;

    /// <summary>
    /// SetTooltipText.
    /// Set the tooltip text for the resource.
    /// </summary>
    /// <param name="Tooltip">Text.</param>
    internal procedure SetTooltipText(Tooltip: Text)
    begin
        UpdateExtendedProps(ToolTipLbl, Tooltip);
    end;

    /// <summary>
    /// UpdateValue.
    /// </summary>
    /// <param name="ResouceProperty">Text.</param>
    /// <param name="ResourceValue">Variant.</param>
    local procedure UpdateValue(ResouceProperty: Text; ResourceValue: Variant)
    var
        JsonHelper: Codeunit PTEJsonHelper;
    begin
        JsonHelper.UpdateJsonObjectField(CurrentResource, ResouceProperty, ResourceValue);
    end;

    /// <summary>
    /// UpdateExtendedProps.
    /// Update the extended properties.
    /// </summary>
    /// <param name="EventProperty">Text.</param>
    /// <param name="EventValue">Variant.</param>
    local procedure UpdateExtendedProps(EventProperty: Text; EventValue: Variant)
    var
        JsonHelper: Codeunit PTEJsonHelper;
        ExtProps: JsonObject;
        JToken: JsonToken;
    begin
        if not CurrentResource.Get(ExtendedPropsLbl, JToken) then
            CurrentResource.Add(ExtendedPropsLbL, ExtProps);

        JsonHelper.UpdateJsonObjectField(ExtProps, EventProperty, EventValue);
        JsonHelper.UpdateJsonObjectField(CurrentResource, ExtendedPropsLbL, ExtProps);
    end;
}
