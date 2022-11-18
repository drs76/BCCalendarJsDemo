
/// <summary>
/// Codeunit PTEFullCalendarGreenAmberRed (ID 50145).
/// https://fullcalendar.io/docs/GAR-object
/// </summary>
codeunit 50145 PTEFullCalendarGreenAmberRed
{
    var
        GARCollection: Dictionary of [Text, Text];
        CurrentGAR: JsonObject;
        IdToken: JsonToken;
        IdLbl: Label 'id';
        PostCode1Lbl: Label 'postcode1';
        PostCode2Lbl: Label 'postcode2';
        ColorLbl: Label 'color';
        InvalidIdErr: Label 'Invalid Id. Cannot be empty.';
        EmptyTxt: Label '';


    /// <summary>
    /// ClearGAR.
    /// </summary>
    internal procedure ClearGAR()
    begin
        Clear(GARCollection);
    end;

    /// <summary>
    /// CreateGAR.
    /// </summary>
    /// <param name="Id">Text.</param>
    internal procedure CreateGAR(Id: Text)
    begin
        Clear(CurrentGAR);
        CurrentGAR.Add(IdLbl, Id);
    end;

    /// <summary>
    /// AddGARToCollection.
    /// Add current resource to the GAR collection.
    /// </summary>
    internal procedure AddGARToCollection()
    begin
        AddGARToCollection(CurrentGAR);
    end;

    /// <summary>
    /// AddGARToCollection.
    /// Add or Replace current resource to the GARs collection.
    /// </summary>
    /// <param name="GARToAdd">JsonObject.</param>
    internal procedure AddGARToCollection(GARToAdd: JsonObject)
    var
        GARText: Text;
    begin
        if not GARToAdd.Get(IdLbl, IdToken) then
            exit;

        GARToAdd.WriteTo(GARText);
        if GARCollection.ContainsKey(IdToken.AsValue().AsText()) then
            GARCollection.Remove(IdToken.AsValue().AsText());

        GARCollection.Add(IdToken.AsValue().AsText(), GARText);
    end;

    /// <summary>
    /// UpdateGARInCollection.
    /// </summary>
    /// <param name="GARToUpdate">JsonObject.</param>
    internal procedure UpdateGARInCollection(GARToUpdate: JsonObject)
    var
        GARText: Text;
    begin
        if not GARToUpdate.Get(IdLbl, IdToken) then
            exit;

        if not GARCollection.ContainsKey(IdToken.AsValue().AsText()) then begin
            AddGARToCollection(GARToUpdate);
            exit;
        end;

        GARToUpdate.WriteTo(GARText);
        GARCollection.Set(IdToken.AsValue().AsText(), GARText);
    end;

    /// <summary>
    /// DeleteGARFromCollection.
    /// </summary>
    /// <param name="Id">Text.</param>
    internal procedure DeleteGARFromCollection(Id: Text)
    begin
        if GARCollection.ContainsKey(Id) then
            GARCollection.Remove(Id);
    end;

    /// <summary>
    /// DeleteGARFromCollection.
    /// </summary>
    /// <param name="GARToDelete">JsonObject.</param>
    internal procedure DeleteGARFromCollection(GARToDelete: JsonObject)
    begin
        if GARToDelete.Get(IdLbl, IdToken) then
            if GARCollection.ContainsKey(IdToken.AsValue().AsText()) then
                GARCollection.Remove(IdToken.AsValue().AsText());
    end;

    /// <summary>
    /// GetGARFromCollection.
    /// </summary>
    /// <param name="Id">Text.</param>
    /// <returns>Return variable ReturnValue of type JsonObject.</returns>
    internal procedure GetGARFromCollection(Id: Text) ReturnValue: JsonObject
    var
        GARText: Text;
    begin
        if not GARCollection.Get(Id, GARText) then
            Error(InvalidIdErr);

        ReturnValue.ReadFrom(GARText);
    end;

    /// <summary>
    /// GetRedAmberGreens.
    /// </summary>
    /// <returns>Return value of type JsonArray.</returns>
    internal procedure GetRedAmberGreens() ReturnValue: JsonArray
    var
        GARObject: JsonObject;
        GARText: Text;
        Id: Text;
    begin
        foreach Id in GARCollection.Keys() do
            if GARCollection.Get(Id, GARText) then begin
                GARObject.ReadFrom(GARText);
                ReturnValue.Add(GARObject);
            end;
    end;

    /// <summary>
    /// GetCurrentGAR.
    /// </summary>
    /// <returns>Return value of type JsonObject.</returns>
    internal procedure GetCurrentGAR(): JsonObject
    begin
        exit(CurrentGAR);
    end;

    /// <summary>
    /// SetCurrentGAR.
    /// </summary>
    /// <param name="Id">Text.</param>
    /// <returns>Return value of type JsonObject.</returns>
    internal procedure SetCurrentGAR(Id: Text)
    var
        GARText: Text;
    begin
        if GARCollection.ContainsKey(Id) then begin
            GARCollection.Get(Id, GARText); //sets the current GAR.
            CurrentGAR.ReadFrom(GARText);
            exit;
        end;
        Error(InvalidIdErr);
    end;

    /// <summary>
    /// SetCurrentGAR.
    /// </summary>
    /// <param name="GARToSet">JsonObject.</param>
    internal procedure SetCurrentGAR(GARToSet: JsonObject)
    var
        GARString: Text;
        InvalidObjectErr: Label 'Invalid GAR Object:\%1', Comment = '%1 = Object String';
    begin
        if not GARToSet.Get(IdLbl, IdToken) then
            Error(InvalidIdErr);

        GARToSet.WriteTo(GARString);
        if not CurrentGAR.ReadFrom(GARString) then
            Error(InvalidObjectErr, GARToSet.AsToken().AsValue().AsText());
    end;

    /// <summary>
    /// SetGARCollection.
    /// </summary>
    /// <param name="GARCollectionToSet">JsonArray.</param>
    internal procedure SetGARCollection(GARCollectionToSet: JsonArray)
    begin
        ClearGAR();
        AppendGARCollection(GARCollectionToSet);
    end;

    /// <summary>
    /// AppendGARCollection.
    /// </summary>
    /// <param name="GARCollectionToAppend">JsonArray.</param>
    internal procedure AppendGARCollection(GARCollectionToAppend: JsonArray)
    var
        GARToken: JsonToken;
        GARObject: JsonObject;
    begin
        foreach GARToken in GARCollectionToAppend do begin
            GARObject.ReadFrom(GARToken.AsValue().AsText());
            if GARObject.Get(IdLbl, IdToken) then
                GARCollection.Add(IdToken.AsValue().AsText(), GARToken.AsValue().AsText());
        end;
    end;

    /// <summary>
    /// SetId.
    /// Set the GAR unique Id.
    /// </summary>
    /// <param name="Id">Text.</param>
    internal procedure SetId(Id: Text)
    begin
        if Id = EmptyTxt then
            Error(InvalidIdErr);

        UpdateValue(IdLbl, Id);
    end;

    /// <summary>
    /// SetPostCode1.
    /// </summary>
    /// <param name="Postcode">Text.</param>
    internal procedure SetPostCode1(Postcode: Text)
    begin
        UpdateValue(PostCode1Lbl, Postcode);
    end;

    /// <summary>
    /// SetPostCode2.
    /// </summary>
    /// <param name="Postcode">Text.</param>
    internal procedure SetPostCode2(Postcode: Text)
    begin
        UpdateValue(PostCode2Lbl, Postcode);
    end;

    /// <summary>
    /// SetColor.
    /// </summary>
    /// <param name="Color">Text.</param>
    internal procedure SetColor(Color: Text)
    begin
        UpdateValue(ColorLbl, Color);
    end;

    /// <summary>
    /// UpdateValue.
    /// </summary>
    /// <param name="GARProperty">Text.</param>
    /// <param name="GARValue">Variant.</param>
    local procedure UpdateValue(GARProperty: Text; GARValue: Variant)
    var
        JsonHelper: Codeunit PTEJsonHelper;
    begin
        JsonHelper.UpdateJsonObjectField(CurrentGAR, GARProperty, GARValue);
    end;
}