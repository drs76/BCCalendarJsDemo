codeunit 50201 PTECalendarJsJsonHelper
{
    internal procedure UpdateJsonObjectField(var JObject: JsonObject; Property: Text; ValueToSet: Variant)
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

    local procedure SetJsonIntField(var JObject: JsonObject; Property: Text; ValueToSet: Integer)
    begin
        if not JObject.Contains(Property) then
            JObject.Add(Property, ValueToSet)
        else
            JObject.Replace(Property, ValueToSet);
    end;

    local procedure SetJsonDecField(var JObject: JsonObject; Property: Text; ValueToSet: Decimal)
    begin
        if not JObject.Contains(Property) then
            JObject.Add(Property, ValueToSet)
        else
            JObject.Replace(Property, ValueToSet);
    end;

    local procedure SetJsonObjectField(var JObject: JsonObject; Property: Text; ValueToSet: JsonObject)
    begin
        if not JObject.Contains(Property) then
            JObject.Add(Property, ValueToSet)
        else
            JObject.Replace(Property, ValueToSet);
    end;

    local procedure SetJsonArrayField(var JObject: JsonObject; Property: Text; ValueToSet: JsonArray)
    begin
        if not JObject.Contains(Property) then
            JObject.Add(Property, ValueToSet)
        else
            JObject.Replace(Property, ValueToSet);
    end;

    local procedure SetJsonBooleanField(var JObject: JsonObject; Property: Text; ValueToSet: Boolean)
    begin
        if not JObject.Contains(Property) then
            JObject.Add(Property, ValueToSet)
        else
            JObject.Replace(Property, ValueToSet);
    end;

    internal procedure GetJsonTextField(JObject: JsonObject; KeyName: Text): Text
    var
        Result: JsonToken;
    begin
        if JObject.Get(KeyName, Result) then
            exit(Result.AsValue().AsText());
    end;

    internal procedure GetJsonIntegerField(JObject: JsonObject; KeyName: Text): Integer
    var
        Result: JsonToken;
    begin
        if JObject.Get(KeyName, Result) then
            exit(Result.AsValue().AsInteger());
    end;

    internal procedure GetJsonDecimalField(JObject: JsonObject; KeyName: Text): Decimal
    var
        Result: JsonToken;
    begin
        if JObject.Get(KeyName, Result) then
            exit(Result.AsValue().AsDecimal());
    end;

    internal procedure GetJsonObjectField(JObject: JsonObject; KeyName: Text): JsonObject
    var
        Result: JsonToken;
    begin
        if JObject.Get(KeyName, Result) then
            exit(Result.AsObject());
    end;

    internal procedure GetJsonArrayField(JObject: JsonObject; KeyName: Text): JsonArray
    var
        Result: JsonToken;
    begin
        if JObject.Get(KeyName, Result) then
            exit(Result.AsArray());
    end;

    internal procedure JsonArrayToDictionary(JsonArrayIn: JsonArray; var DictionaryOut: Dictionary of [Text, Text]; KeyName: Text; ValueName: Text)
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

    internal procedure DictionaryToJsonArray(var JsonArrayOut: JsonArray; DictionaryIn: Dictionary of [Text, Text]; PropertyName: Text; ValueName: Text)
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

    internal procedure RecordToJson(RecordToConvert: Variant) ReturnValue: JsonObject
    begin
        exit(RecordToJson(RecordToConvert, false));
    end;

    internal procedure RecordToJson(RecordToConvert: Variant; UseSystemFields: Boolean) ReturnValue: JsonObject
    var
        Fields: Record Field;
        RecRef: RecordRef;
        WrongTypeErr: Label 'RecordToConvert must be type Recored.';
    begin
        if not RecordToConvert.IsRecord() then
            Error(WrongTypeErr);

        RecRef.GetTable(RecordToConvert);
        if not GetFields(RecRef.Number(), Fields, UseSystemFields) then
            exit;

        ProcessToJson(RecRef, Fields, ReturnValue);
    end;

    local procedure ProcessToJson(RecRef: RecordRef; var Fields: Record Field; var ReturnValue: JsonObject)
    begin
        repeat
            AddValueForJsonType(RecRef, Fields, ReturnValue);
        until Fields.Next() = 0;
    end;

    local procedure AddValueForJsonType(RecRef: RecordRef; Fields: Record Field; var ReturnValue: JsonObject)
    var
        JArray: JsonArray;
        JObject: JsonObject;
        TextVal: Text;
        BooleanValue: Boolean;
        IntegerValue: Integer;
        DecimalValue: Decimal;
        DateValue: Date;
        TimeValue: Time;
        DurationValue: Duration;
        DateTimeValue: DateTime;
    begin
        if Fields.Class = Fields.Class::FlowField then
            RecRef.Field(Fields."No.").CalcField();

        case Fields.Type of
            Fields.Type::Boolean:
                if Evaluate(BooleanValue, Format(RecRef.Field(Fields."No.").Value)) then
                    ReturnValue.Add(GetSafeFieldName(Fields), BooleanValue);
            Fields.Type::Code, Fields.Type::Text:
                begin
                    TextVal := Format(RecRef.Field(Fields."No.").Value);
                    if StrLen(TextVal) = 0 then begin
                        ReturnValue.Add(GetSafeFieldName(Fields), Format(RecRef.Field(Fields."No.").Value));
                        exit;
                    end;

                    if (CopyStr(TextVal, 1, 1) = '[') and (CopyStr(TextVal, StrLen(TextVal), 1) = ']') then begin
                        JArray.ReadFrom(TextVal);
                        ReturnValue.Add(GetSafeFieldName(Fields), JArray);
                        exit;
                    end;
                    if (CopyStr(TextVal, 1, 1) = '{') and (CopyStr(TextVal, StrLen(TextVal), 1) = '}') then begin
                        JObject.ReadFrom(TextVal);
                        ReturnValue.Add(GetSafeFieldName(Fields), JObject);
                        exit;
                    end;
                    ReturnValue.Add(GetSafeFieldName(Fields), Format(RecRef.Field(Fields."No.").Value));
                end;
            Fields.Type::Integer:
                if Evaluate(IntegerValue, Format(RecRef.Field(Fields."No.").Value)) then
                    ReturnValue.Add(GetSafeFieldName(Fields), IntegerValue);
            Fields.Type::Decimal:
                if Evaluate(DecimalValue, Format(RecRef.Field(Fields."No.").Value)) then
                    ReturnValue.Add(GetSafeFieldName(Fields), DecimalValue);
            Fields.Type::Date:
                if Evaluate(DateValue, Format(RecRef.Field(Fields."No.").Value)) then
                    ReturnValue.Add(GetSafeFieldName(Fields), DateValue);
            Fields.Type::Time:
                if Evaluate(TimeValue, Format(RecRef.Field(Fields."No.").Value)) then
                    ReturnValue.Add(GetSafeFieldName(Fields), TimeValue);
            Fields.Type::Duration:
                if Evaluate(DurationValue, Format(RecRef.Field(Fields."No.").Value)) then
                    ReturnValue.Add(GetSafeFieldName(Fields), DurationValue);
            Fields.Type::DateTime:
                if Evaluate(DateTimeValue, Format(RecRef.Field(Fields."No.").Value)) then
                    ReturnValue.Add(GetSafeFieldName(Fields), DateTimeValue);
            Fields.Type::Option:
                ReturnValue.Add(GetSafeFieldName(Fields), Format(RecRef.Field(Fields."No.").Value));
        end;
    end;

    local procedure GetFields(TableNo: Integer; var Fields: Record Field; UseSystemFields: Boolean): Boolean
    var
        CommpanyInfo: Record "Company Information";
        PinUpViewImageUrlsLbl: Label 'pinUpViewImageUrls';
        InitialDateTimeLbl: Label 'initialDateTime';
        DefaultLbl: Label 'Default';
        DescriptionLbl: Label 'Description';
    begin
        Fields.SetRange(TableNo, TableNo);
        Fields.SetRange(ObsoleteState, Fields.ObsoleteState::No);
        if not UseSystemFields then begin
            Fields.SetFilter("No.", '<%1', CommpanyInfo.FieldNo(SystemId));
            Fields.SetRange(IsPartOfPrimaryKey, false);
            if TableNo = DataBase::PTECalendarJsSetup then
                Fields.SetFilter("Field Caption", '<>%1&<>%2&<>%3&<>%4', PinUpViewImageUrlsLbl, InitialDateTimeLbl, DefaultLbl, DescriptionLbl);
        end;
        exit(Fields.FindSet());
    end;

    local procedure GetSafeFieldName(Fields: Record Field) ReturnValue: Text
    var
        AppendLbl: Label '%1%2';
    begin
        ReturnValue := Fields."Field Caption";
        ReturnValue := StrSubstNo(AppendLbl, LowerCase(Format(ReturnValue[1])), CopyStr(ReturnValue, 2, StrLen(ReturnValue)));
    end;

    internal procedure JsonToRecord(var RecRef: RecordRef; JsonText: Text)
    var
        EventJO: JsonObject;
        Prop: Text;
    begin
        EventJO.ReadFrom(JsonText);
        foreach Prop in EventJO.Keys() do
            ProcessFieldToRec(RecRef, Prop, EventJO);
    end;

    local procedure ProcessFieldToRec(var RecRef: RecordRef; Prop: Text; EventJO: JsonObject)
    var
        Fields: Record Field;
        TempBlob: Codeunit "Temp Blob";
        JToken: JsonToken;
        WriteStream: OutStream;
        FieldFilterTxt: Label '@%1';
    begin
        Fields.SetRange(TableNo, RecRef.Number());
        Fields.SetFilter(FieldName, FieldFilterTxt, Prop);
        if not Fields.FindFirst() then
            exit;

        if Fields.Class = Fields.Class::FlowField then
            RecRef.Field(Fields."No.").CalcField();

        if Fields.Class = Fields.Type::Blob then
            RecRef.Field(Fields."No.").CalcField();

        EventJO.Get(Prop, JToken);

        case Fields.Type of
            Fields.Type::Text, Fields.Type::Code:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsText();
            Fields.Type::Decimal:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsDecimal();
            Fields.Type::Integer:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsInteger();
            Fields.Type::DateTime:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsDateTime();
            Fields.Type::Date:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsDate();
            Fields.Type::Time:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsTime();
            Fields.Type::Boolean:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsBoolean();
            Fields.Type::Blob:
                begin
                    TempBlob.CreateOutStream(WriteStream, TextEncoding::UTF8);
                    WriteStream.WriteText(JToken.AsValue().AsText());
                    TempBlob.ToRecordRef(RecRef, Fields."No.");
                end;
        end;
    end;
}
