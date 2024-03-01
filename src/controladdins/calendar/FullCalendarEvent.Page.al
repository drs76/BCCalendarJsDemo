/// <summary>
/// Page PTEFullCalendarEvent (ID 50102).
/// </summary>
page 50201 PTEFullCalendarEvent
{
    Caption = 'Calendar Event';
    PageType = NavigatePage;
    UsageCategory = None;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            field(FldId; Id)
            {
                ApplicationArea = All;
                Caption = 'Id';
                ToolTip = 'Specifies the event id.';
                Editable = false;
                Visible = true;
            }

            field(FldTitle; Title)
            {
                ApplicationArea = All;
                Caption = 'Title';
                ToolTip = 'Specifies the event title.';
                MultiLine = true;
            }

            field(FldStartDate; StartDate)
            {
                ApplicationArea = All;
                Caption = 'Start';
                ToolTip = 'Specifies the event start date time.';
            }

            field(FldAllDay; AllDay)
            {
                ApplicationArea = All;
                Caption = 'All Day';
                ToolTip = 'Specifies if this is an all day event.';

                trigger OnValidate()
                begin
                    CurrPage.Update(false);
                end;
            }

            field(FldEndDate; EndDate)
            {
                ApplicationArea = All;
                Caption = 'End';
                ToolTip = 'Specifies the event end date time.';
                Enabled = EditEndDate;
            }

            field(FldBackground; Background)
            {
                ApplicationArea = All;
                Caption = 'Background';
                ToolTip = 'Set the event background color.';
            }

            usercontrol(FldCBgolorPicker; PTEColorPicker)
            {
                ApplicationArea = All;
                trigger ControlReady()
                begin
                    CurrPage.FldCBgolorPicker.Init();
                    Control1Ready := true;
                end;
            }

            field(FldTextColour; TextColor)
            {
                ApplicationArea = All;
                Caption = 'Text Colour';
                ToolTip = 'Set the event text colour.';
            }

            usercontrol(FldTextColorPicker; PTEColorPicker)
            {
                ApplicationArea = All;
                trigger ControlReady()
                begin
                    CurrPage.FldTextColorPicker.Init();
                    Control2Ready := true;
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Delete)
            {
                ApplicationArea = All;
                Image = Delete;
                Caption = 'Delete';
                ToolTip = 'Delete the event and exit.';
                InFooterBar = true;
                Visible = not Adding and not Dragged;

                trigger OnAction()
                var
                    ConfirmDelQst: Label 'Are you sure you want to delete this event.';
                begin
                    if not Confirm(ConfirmDelQst, false) then
                        exit;

                    DeleteData := true;
                    CurrPage.Close();
                end;
            }

            action(Save)
            {
                ApplicationArea = All;
                Image = Save;
                Caption = 'Save';
                ToolTip = 'Save chanegs to event and exit.';
                InFooterBar = true;

                trigger OnAction()
                begin
                    Clear(CancelSave);
                    SaveData := true;
                    CurrPage.Close();
                end;
            }

            action(Cancel)
            {
                ApplicationArea = All;
                Image = Cancel;
                Caption = 'Cancel';
                ToolTip = 'Cancel chanegs to event and exit.';
                InFooterBar = true;

                trigger OnAction()
                begin
                    Clear(SaveData);
                    CancelSave := true;
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not DeleteData then
            if not CancelSave then
                if not SaveData then
                    SaveData := Confirm(ConfirmSaveQst, false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetControls();
    end;

    var
        Id: Text;
        ResourceId: Text;
        Title: Text;
        StartDate: DateTime;
        EndDate: DateTime;
        Adding: Boolean;
        AllDay: Boolean;
        SaveData: Boolean;
        CancelSave: Boolean;
        DeleteData: Boolean;
        Dragged: Boolean;
        Control1Ready: Boolean;
        Control2Ready: Boolean;
        ConfirmSaveQst: Label 'Save changes.';
        IdLbl: Label 'id';
        TitleLbl: Label 'title';
        StartLbl: Label 'start';
        EndLbl: Label 'end';
        AllDayLbl: Label 'allDay';
        ColorLbl: Label 'backgroundColor';
        ResourceIdLbl: Label 'resourceId';
        TextColorLbl: Label 'textColor';
        EditEndDate: Boolean;
        Background: Text;
        TextColor: Text;


    /// <summary>
    /// InitPage.
    /// </summary>
    /// <param name="Entry">JsonObject.</param>
    /// <param name="addingIn">Boolean.</param>
    internal procedure InitPage(Entry: JsonObject; addingIn: Boolean)
    begin
        Id := GetValueSafely(IdLbl, Entry, Id);
        ResourceId := GetValueSafely(ResourceIdLbl, Entry, ResourceId);
        Title := GetValueSafely(TitleLbl, Entry, Title);
        StartDate := GetValueSafely(StartLbl, Entry, StartDate);
        EndDate := GetValueSafely(EndLbl, Entry, EndDate);
        AllDay := GetValueSafely(AllDayLbl, Entry, AllDay);
        Background := GetValueSafely(ColorLbl, Entry, Background);
        TextColor := GetValueSafely(TextColorLbl, Entry, TextColor);

        Adding := addingIn;
        if Adding then
            Id := CreateGuid();

        EditEndDate := not AllDay;
    end;

    /// <summary>
    /// GetValueSafely.
    /// </summary>
    /// <param name="PropName">Text.</param>
    /// <param name="Entry">JsonObject.</param>
    /// <param name="ForField">Variant.</param>
    /// <returns>Return variable ReturnValue of type Variant.</returns>
    internal procedure GetValueSafely(PropName: Text; Entry: JsonObject; ForField: Variant): Variant
    var
        JToken: JsonToken;
        ConvertedDT: DateTime;
        ConvertedBool: Boolean;
        EmptyTxt: Label '';
    begin
        if Entry.Get(PropName, JToken) then
            if JToken.IsValue() then
                if not JToken.AsValue().IsNull() then
                    case true of
                        ForField.IsText():
                            exit(JToken.AsValue().AsText());
                        ForField.IsDateTime():
                            if Evaluate(ConvertedDT, JToken.AsValue().AsText()) then
                                exit(ConvertedDT);
                        ForField.IsBoolean():
                            if Evaluate(ConvertedBool, JToken.AsValue().AsText()) then
                                exit(ConvertedBool)
                            else
                                exit(false);
                    end;
        // didnt find anything above, return default for the field.
        case true of
            ForField.IsText():
                exit(EmptyTxt);
            ForField.IsDateTime():
                exit(0DT);
            ForField.IsBoolean():
                exit(false);
        end;
    end;

    /// <summary>
    /// SaveTheData.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure SaveTheData(): Boolean
    begin
        exit(SaveData);
    end;

    /// <summary>
    /// DeleteTheData.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure DeleteTheData(): Boolean
    begin
        exit(DeleteData);
    end;

    /// <summary>
    /// GetResult.
    /// </summary>
    /// <param name="JResult">VAR JsonObject.</param>
    /// <returns>Boolean.</returns>
    internal procedure GetResult(var JResult: JsonObject): Boolean
    var
        UpdateLbl: Label 'update';
        DeleteLbl: Label 'deleteMe';
    begin
        JResult.Add(IdLbl, id);
        JResult.Add(ResourceIdLbl, ResourceId);
        JResult.Add(TitleLbl, Title);
        JResult.Add(StartLbl, StartDate);
        JResult.Add(EndLbl, EndDate);
        JResult.Add(AllDayLbl, AllDay);
        JResult.Add(ColorLbl, Background);
        JResult.Add(TextColorLbl, TextColor);
        JResult.Add(Updatelbl, SaveData);
        JResult.Add(DeleteLbl, DeleteData);

        exit(SaveData or DeleteData);
    end;

    /// <summary>
    /// SetDragged.
    /// </summary>
    /// <param name="SetValue">Boolean.</param>
    internal procedure SetDragged(SetValue: Boolean)
    begin
        Dragged := SetValue;
    end;

    /// <summary>
    /// SetControls.
    /// </summary>
    local procedure SetControls()
    begin
        EditEndDate := not AllDay;
        if Control1Ready then
            CurrPage.FldCBgolorPicker.SetColour(Background);

        if Control2Ready then
            CurrPage.FldTextColorPicker.SetColour(TextColor);
    end;
}
