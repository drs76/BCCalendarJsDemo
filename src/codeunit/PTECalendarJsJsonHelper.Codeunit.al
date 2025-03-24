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
        ExtraJO: JsonObject;
        WrongTypeErr: Label 'RecordToConvert must be type Record.';
        SideMenuLbl: Label 'sideMenu';
    begin
        if not RecordToConvert.IsRecord() then
            Error(WrongTypeErr);

        RecRef.GetTable(RecordToConvert);
        if RecRef.Number() = Database::PTECalendarJsViewOption then
            if GetFieldsForView(RecRef.Number(), Fields, RecRef) then
                ProcessToJson(RecRef, Fields, ReturnValue);

        if RecRef.Number() <> Database::PTECalendarJsViewOption then
            if GetFields(RecRef.Number(), Fields, UseSystemFields) then
                ProcessToJson(RecRef, Fields, ReturnValue);

        if RecRef.Number() = Database::PTECalendarJsSetup then begin
            if not GetFieldsForSideMenu(RecRef.Number(), Fields) then
                exit;

            ProcessToJson(RecRef, Fields, ExtraJO);
            ReturnValue.Add(SideMenuLbl, ExtraJO);
        end;
    end;

    local procedure ProcessToJson(RecRef: RecordRef; var Fields: Record Field; var ReturnValue: JsonObject)
    begin
        repeat
            AddValueForJsonType(RecRef, Fields, ReturnValue);
        until Fields.Next() = 0;
    end;

    local procedure AddValueForJsonType(RecRef: RecordRef; Fields: Record Field; var ReturnValue: JsonObject)
    var
        TempBlob: Codeunit "Temp Blob";
        JArray: JsonArray;
        JObject: JsonObject;
        ReadStream: InStream;
        TextVal: Text;
        BooleanValue: Boolean;
        IntegerValue: Integer;
        DecimalValue: Decimal;
        DateValue: Date;
        TimeValue: Time;
        DurationValue: Duration;
        DateTimeValue: DateTime;
        EmptyObjTxt: Label '{}';
        EmptyArrTxt: Label '[]';
    begin
        if (Fields.Class = Fields.Class::FlowField) or (Fields.Type = Fields.Type::BLOB) then
            RecRef.Field(Fields."No.").CalcField();

        case Fields.Type of
            Fields.Type::Boolean:
                if Evaluate(BooleanValue, Format(RecRef.Field(Fields."No.").Value)) then
                    ReturnValue.Add(GetSafeFieldName(Fields), BooleanValue);
            Fields.Type::Code, Fields.Type::Text, Fields.Type::BLOB:
                begin
                    if Fields.Type = Fields.Type::BLOB then begin
                        TempBlob.FromRecordRef(RecRef, Fields."No.");
                        TempBlob.CreateInStream(ReadStream, TextEncoding::UTF8);
                        ReadStream.ReadText(TextVal);
                        if TextVal = '' then begin
                            if IsObjectField(Fields) then
                                TextVal := EmptyObjTxt;
                            if IsArrayField(Fields) then
                                TextVal := EmptyArrTxt;
                        end;
                    end else
                        TextVal := Format(RecRef.Field(Fields."No.").Value);

                    if StrLen(TextVal) > 0 then begin
                        if IsArrayField(Fields) then
                            if (CopyStr(TextVal, 1, 1) = '[') and (CopyStr(TextVal, StrLen(TextVal), 1) = ']') then begin
                                JArray.ReadFrom(TextVal);
                                ReturnValue.Add(GetSafeFieldName(Fields), JArray);
                                exit;
                            end;
                        if IsObjectField(Fields) then
                            if (CopyStr(TextVal, 1, 1) = '{') and (CopyStr(TextVal, StrLen(TextVal), 1) = '}') then begin
                                JObject.ReadFrom(TextVal);
                                ReturnValue.Add(GetSafeFieldName(Fields), JObject);
                                exit;
                            end;
                    end;
                    ReturnValue.Add(GetSafeFieldName(Fields), TextVal);
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
                ReturnValue.Add(GetSafeFieldName(Fields), RecRef.Field(Fields."No.").OptionMembers.IndexOf(Format(RecRef.Field(Fields."No.").Value)));
            Fields.Type::GUID:
                if not IsNullGuid(RecRef.Field(Fields."No.").Value) then
                    ReturnValue.Add(GetSafeFieldName(Fields), DelChr(DelChr(Format(RecRef.Field(Fields."No.").Value), '=', '{'), '=', '}'));
        end;
    end;

    local procedure GetFields(TableNo: Integer; var Fields: Record Field; UseSystemFields: Boolean): Boolean
    var
        PinUpViewImageUrlsLbl: Label 'pinUpViewImageUrls';
        InitialDateTimeLbl: Label 'initialDateTime';
        DefaultLbl: Label 'Default';
        DescriptionLbl: Label 'Description';
    begin
        Fields.Reset();
        Fields.SetRange(TableNo, TableNo);
        Fields.SetRange(ObsoleteState, Fields.ObsoleteState::No);
        if not UseSystemFields then
            case TableNo of
                Database::PTECalendarJsEvent:
                    Fields.SetRange("No.", 5, 48);
                else begin
                    Fields.SetFilter("No.", '<%1', Fields.FieldNo(SystemId));
                    Fields.SetRange(IsPartOfPrimaryKey, false);
                    if TableNo = DataBase::PTECalendarJsSetup then
                        Fields.SetFilter("Field Caption", '<>%1&<>%2&<>%3&<>%4', PinUpViewImageUrlsLbl, InitialDateTimeLbl, DefaultLbl, DescriptionLbl);
                end;
            end;
        exit(Fields.FindSet());
    end;

    local procedure GetFieldsForSideMenu(TableId: Integer; var Fields: Record Field): Boolean
    begin
        Fields.Reset();
        Fields.SetRange(TableNo, TableId);
        Fields.SetRange("No.", 49, 53);
    end;

    local procedure GetFieldsForView(TableId: Integer; var Fields: Record Field; RecRef: RecordRef): Boolean
    var
        CalendarJSView: Record PTECalendarJsViewOption;
    begin
        Fields.Reset();
        Fields.SetRange(TableNo, TableId);
        RecRef.SetTable(CalendarJSView);
        case CalendarJSView.CalendarView of
            PTECalendarJSViews::allEvents:
                Fields.SetFilter("No.", '%1', 6);
            PTECalendarJSViews::fullDay:
                Fields.SetFilter("No.", '%1..%2', 3, 6);
            PTECalendarJSViews::fullMonth:
                Fields.SetFilter("No.", '%1..%2|%3|%4|%5', 9, 17, 7, 20, 6);
            PTECalendarJSViews::fullWeek:
                Fields.SetFilter("No.", '%1..%2|%3', 3, 6, 7);
            PTECalendarJSViews::fullYear:
                Fields.SetFilter("No.", '%1', 6);
            PTECalendarJSViews::timeline:
                Fields.SetFilter("No.", '%1|%2|%3', 21, 4, 6);
            else
                exit(false);
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

    internal procedure JsonToRecord(var RecRef: RecordRef; CalEvent: JsonObject)
    var
        PropMap: Dictionary of [Text, Integer];
        Prop: Text;
        i: Integer;
    begin
        for i := 1 to RecRef.FieldCount() do
            if RecRef.FieldExist(i) then
                PropMap.Add(RecRef.Field(i).Name.ToUpper(), i);

        foreach Prop in CalEvent.Keys() do
            if PropMap.Get(GetPropNameTranslation(Prop).ToUpper(), i) then
                ProcessFieldToRec(RecRef, Prop, CalEvent, i);
    end;

    local procedure ProcessFieldToRec(var RecRef: RecordRef; Prop: Text; CalEvent: JsonObject; FieldNo: Integer)
    var
        Fields: Record Field;
        TempBlob: Codeunit "Temp Blob";
        JToken: JsonToken;
        JObject: JsonObject;
        JArray: JsonArray;
        JText: Text;
        WriteStream: OutStream;
        GuidVal: Guid;
        IntVal: Integer;
    begin
        if not CalEvent.Get(Prop, JToken) then
            exit;

        if not CheckForNull(JToken) then
            exit;

        if not Fields.Get(RecRef.Number(), FieldNo) then
            exit;

        if Fields.Class = Fields.Class::FlowField then
            RecRef.Field(Fields."No.").CalcField();

        if Fields.Class = Fields.Type::Blob then
            RecRef.Field(Fields."No.").CalcField();

        case Fields.Type of
            Fields.Type::Text, Fields.Type::Code:
                begin
                    if JToken.IsArray() then begin
                        JArray := JToken.AsArray();
                        JArray.WriteTo(JText);
                        RecRef.Field(Fields."No.").Value := CopyStr(JText, 1, RecRef.Field(Fields."No.").Length());
                        exit;
                    end;
                    if JToken.IsObject() then begin
                        JObject := JToken.AsObject();
                        JObject.WriteTo(JText);
                        RecRef.Field(Fields."No.").Value := CopyStr(JText, 1, RecRef.Field(Fields."No.").Length());
                        exit;
                    end;
                    RecRef.Field(Fields."No.").Value := JToken.AsValue().AsText();
                end;
            Fields.Type::Decimal:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsDecimal();
            Fields.Type::Integer:
                if Evaluate(IntVal, JToken.AsValue().AsText()) then
                    RecRef.Field(Fields."No.").Value := IntVal;
            Fields.Type::DateTime:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsDateTime();
            Fields.Type::Date:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsDate();
            Fields.Type::Time:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsTime();
            Fields.Type::Boolean:
                RecRef.Field(Fields."No.").Value := JToken.AsValue().AsBoolean();
            Fields.Type::GUID:
                begin
                    Evaluate(GuidVal, JToken.AsValue().AsText());
                    RecRef.Field(Fields."No.").Value := GuidVal;
                end;
            Fields.Type::Blob:
                begin
                    TempBlob.CreateOutStream(WriteStream, TextEncoding::UTF8);
                    if JToken.IsArray() then begin
                        JArray := JToken.AsArray();
                        JArray.WriteTo(WriteStream);
                        TempBlob.ToRecordRef(RecRef, Fields."No.");
                        exit;
                    end;
                    if JToken.IsObject() then begin
                        JObject := JToken.AsObject();
                        JObject.WriteTo(WriteStream);
                        TempBlob.ToRecordRef(RecRef, Fields."No.");
                        exit;
                    end;
                    WriteStream.WriteText(JToken.AsValue().AsText());
                    TempBlob.ToRecordRef(RecRef, Fields."No.");
                end;
        end;
    end;

    [TryFunction]
    local procedure CheckForNull(JToken: JsonToken)
    var
        Jarray: JsonArray;
        Jobject: JsonObject;
        TestText: Text;
    begin
        if JToken.IsArray() then begin
            Jarray := JToken.AsArray();
            exit;
        end;

        if JToken.IsObject() then begin
            Jobject := JToken.AsObject();
            exit;
        end;

        if JToken.IsValue() then
            TestText := JToken.AsValue().AsText();
    end;

    local procedure GetPropNameTranslation(Prop: Text) ReturnValue: Text
    var
        FromLbl: Label 'From';
        From2Lbl: Label 'DTFrom';
        ToLbl: Label 'To';
        To2Lbl: Label 'DTTo';
        TypeLbl: Label 'Type';
        Type2Lbl: Label 'EventType';
        GroupLbl: Label 'EventGroup';
        Group2Lbl: Label 'Group';
    begin
        case Prop.ToUpper() of
            UpperCase(FromLbl):
                ReturnValue := From2Lbl;
            UpperCase(ToLbl):
                ReturnValue := To2Lbl;
            UpperCase(TypeLbl):
                ReturnValue := Type2Lbl;
            UpperCase(GroupLbl):
                ReturnValue := Group2Lbl;
            else
                ReturnValue := Prop;
        end;
    end;

    local procedure IsObjectField(Fields: Record Field): Boolean
    var
        WorkingHoursStartLbl: Label 'workingHoursStart';
        WorkingHoursEndLbl: Label 'workingHoursEnd';
        RepeatEndsLbl: Label 'repeatEnds';
        CustomTagsLbl: Label 'customTags';
        PinUpViewImageUrlLbl: Label 'pinUpViewImageUrls';
    begin
        if Fields.TableNo = Database::PTECalendarJsSetup then begin
            if Fields.FieldName.ToUpper() = UpperCase(WorkingHoursStartLbl) then
                exit(true);
            if Fields.FieldName.ToUpper() = UpperCase(WorkingHoursEndLbl) then
                exit(true);
        end;

        if Fields.TableNo = Database::PTECalendarJsEvent then begin
            if Fields.FieldName.ToUpper() = UpperCase(RepeatEndsLbl) then
                exit(true);

            if Fields.FieldName.ToUpper() = UpperCase(CustomTagsLbl) then
                exit(true);

            if Fields.FieldName.ToUpper() = UpperCase(PinUpViewImageUrlLbl) then
                exit(true);
        end;
    end;

    local procedure IsArrayField(Fields: Record Field): Boolean
    var
        SeriesIgnoreDatesLbl: Label 'seriesIgnoreDates';
        HolidaysLbl: Label 'holidays';
    begin
        if Fields.TableNo = Database::PTECalendarJsSetup then
            if Fields.FieldName.ToUpper() = UpperCase(HolidaysLbl) then
                exit(true);

        if Fields.TableNo = Database::PTECalendarJsEvent then
            if Fields.FieldName.ToUpper() = UpperCase(SeriesIgnoreDatesLbl) then
                exit(true);
    end;
}
