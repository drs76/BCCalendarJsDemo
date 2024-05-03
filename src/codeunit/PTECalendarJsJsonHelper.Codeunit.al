codeunit 50201 PTECalendarJsJsonHelper
{
    procedure UpdateJsonObjectField(var JObject: JsonObject; Property: Text; ValueToSet: Variant)
    var
        JObject2: JsonObject;
        JArray: JsonArray;
        ValueToSetDec: Decimal;
        ValueToSetInt: Integer;
        ValueToSetBool: Boolean;
    begin
        case true of
            ValueToSet.IsDecimal():
                begin
                    Evaluate(ValueToSetDec, Format(ValueToSet));
                    SetJsonDecField(JObject, Property, ValueToSetDec);
                end;
            ValueToSet.IsInteger():
                begin
                    Evaluate(ValueToSetInt, Format(ValueToSet));
                    SetJsonIntField(JObject, Property, ValueToSetInt);
                end;
            ValueToSet.IsDateTime():
                if not JObject.Contains(Property) then
                    JObject.Add(Property, Format(ValueToSet, 0, 9))
                else
                    JObject.Replace(Property, Format(ValueToSet, 0, 9));
            ValueToSet.IsJsonObject():
                begin
                    JObject2 := ValueToSet;
                    SetJsonObjectField(JObject, Property, JObject2);
                end;
            ValueToSet.IsJsonArray():
                begin
                    JArray := ValueToSet;
                    SetJsonArrayField(JObject, Property, JArray);
                end;
            ValueToSet.IsBoolean():
                begin
                    Evaluate(ValueToSetBool, Format(ValueToSet));
                    SetJsonBooleanField(JObject, Property, ValueToSetBool);
                end;
            else
                if not JObject.Contains(Property) then
                    JObject.Add(Property, Format(ValueToSet))
                else
                    JObject.Replace(Property, Format(ValueToSet))
        end;
    end;

    /// <summary>
    /// SetJsonIntField.
    /// </summary>
    /// <param name="JObject">VAR JsonObject.</param>
    /// <param name="Property">Text.</param>
    /// <param name="ValueToSet">Integer.</param>
    local procedure SetJsonIntField(var JObject: JsonObject; Property: Text; ValueToSet: Integer)
    begin
        if not JObject.Contains(Property) then
            JObject.Add(Property, ValueToSet)
        else
            JObject.Replace(Property, ValueToSet);
    end;

    /// <summary>
    /// SetJsonDecField.
    /// </summary>
    /// <param name="JObject">VAR JsonObject.</param>
    /// <param name="Property">Text.</param>
    /// <param name="ValueToSet">Decimal.</param>
    local procedure SetJsonDecField(var JObject: JsonObject; Property: Text; ValueToSet: Decimal)
    begin
        if not JObject.Contains(Property) then
            JObject.Add(Property, ValueToSet)
        else
            JObject.Replace(Property, ValueToSet);
    end;

    /// <summary>
    /// SetJsonObjectField.
    /// </summary>
    /// <param name="JObject">VAR JsonObject.</param>
    /// <param name="Property">Text.</param>
    /// <param name="ValueToSet">JsonObject.</param>
    local procedure SetJsonObjectField(var JObject: JsonObject; Property: Text; ValueToSet: JsonObject)
    begin
        if not JObject.Contains(Property) then
            JObject.Add(Property, ValueToSet)
        else
            JObject.Replace(Property, ValueToSet);
    end;

    /// <summary>
    /// SetJsonArrayField.
    /// </summary>
    /// <param name="JObject">VAR JsonObject.</param>
    /// <param name="Property">Text.</param>
    /// <param name="ValueToSet">JsonArray.</param>
    local procedure SetJsonArrayField(var JObject: JsonObject; Property: Text; ValueToSet: JsonArray)
    begin
        if not JObject.Contains(Property) then
            JObject.Add(Property, ValueToSet)
        else
            JObject.Replace(Property, ValueToSet);
    end;

    /// <summary>
    /// SetJsonBooleanField.
    /// </summary>
    /// <param name="JObject">VAR JsonObject.</param>
    /// <param name="Property">Text.</param>
    /// <param name="ValueToSet">Boolean.</param>
    local procedure SetJsonBooleanField(var JObject: JsonObject; Property: Text; ValueToSet: Boolean)
    begin
        if not JObject.Contains(Property) then
            JObject.Add(Property, ValueToSet)
        else
            JObject.Replace(Property, ValueToSet);
    end;

    /// <summary>
    /// GetJsonTextField.
    /// </summary>
    /// <param name="JObject">JsonObject.</param>
    /// <param name="KeyName">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetJsonTextField(JObject: JsonObject; KeyName: Text): Text
    var
        Result: JsonToken;
    begin
        if JObject.Get(KeyName, Result) then
            exit(Result.AsValue().AsText());
    end;

    /// <summary>
    /// GetJsonIntegerField.
    /// </summary>
    /// <param name="JObject">JsonObject.</param>
    /// <param name="KeyName">Text.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetJsonIntegerField(JObject: JsonObject; KeyName: Text): Integer
    var
        Result: JsonToken;
    begin
        if JObject.Get(KeyName, Result) then
            exit(Result.AsValue().AsInteger());
    end;

    /// <summary>
    /// GetJsonDecimalField.
    /// </summary>
    /// <param name="JObject">JsonObject.</param>
    /// <param name="KeyName">Text.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetJsonDecimalField(JObject: JsonObject; KeyName: Text): Decimal
    var
        Result: JsonToken;
    begin
        if JObject.Get(KeyName, Result) then
            exit(Result.AsValue().AsDecimal());
    end;

    /// <summary>
    /// GetJsonObjectField.
    /// </summary>
    /// <param name="JObject">JsonObject.</param>
    /// <param name="KeyName">Text.</param>
    /// <returns>Return value of type JsonObject.</returns>
    procedure GetJsonObjectField(JObject: JsonObject; KeyName: Text): JsonObject
    var
        Result: JsonToken;
    begin
        if JObject.Get(KeyName, Result) then
            exit(Result.AsObject());
    end;

    /// <summary>
    /// GetJsonArrayField.
    /// </summary>
    /// <param name="JObject">JsonObject.</param>
    /// <param name="KeyName">Text.</param>
    /// <returns>Return value of type JsonArray.</returns>
    procedure GetJsonArrayField(JObject: JsonObject; KeyName: Text): JsonArray
    var
        Result: JsonToken;
    begin
        if JObject.Get(KeyName, Result) then
            exit(Result.AsArray());
    end;

    /// <summary>
    /// JsonArrayToDictionary.
    /// </summary>
    /// <param name="JsonArrayIn">JsonArray.</param>
    /// <param name="DictionaryOut">VAR Dictionary of [Text, Text].</param>
    /// <param name="KeyName">Text.</param>
    /// <param name="ValueName">Text.</param>
    procedure JsonArrayToDictionary(JsonArrayIn: JsonArray; var DictionaryOut: Dictionary of [Text, Text]; KeyName: Text; ValueName: Text)
    var
        ArrayElement: JsonObject;
        JToken: JsonToken;
        KeyName2: Text;
        x: Integer;
    begin
        for x := 0 to JsonArrayIn.Count() - 1 do begin
            JsonArrayIn.Get(x, JToken);
            ArrayElement := JToken.AsObject();

            KeyName2 := GetJsonTextField(ArrayElement, KeyName);
            if KeyName2.Trim() <> '' then
                DictionaryOut.Add(KeyName2, GetJsonTextField(ArrayElement, ValueName));
        end;
    end;

    /// <summary>
    /// DictionaryToJsonArray.
    /// </summary>
    /// <param name="JsonArrayOut">VAR JsonArray.</param>
    /// <param name="DictionaryIn">Dictionary of [Text, Text].</param>
    /// <param name="PropertyName">Text.</param>
    /// <param name="ValueName">Text.</param>
    procedure DictionaryToJsonArray(var JsonArrayOut: JsonArray; DictionaryIn: Dictionary of [Text, Text]; PropertyName: Text; ValueName: Text)
    var
        ArrayElement: JsonObject;
        DictKey: Text;
        DictValue: Text;
    begin
        Clear(JsonArrayOut);
        foreach DictKey in DictionaryIn.Keys() do begin
            DictionaryIn.Get(DictKey, DictValue);

            Clear(ArrayElement);
            ArrayElement.Add(PropertyName, DictKey);
            ArrayElement.Add(ValueName, DictValue);

            JsonArrayOut.Add(ArrayElement);
        end;
    end;
}
