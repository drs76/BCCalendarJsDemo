/// <summary>
/// PageExtension PTEShippingAgents (ID 50147) extends Record Shipping Agents.
/// </summary>
page 50202 PTEShippingAgentsCalendarInfo
{
    Caption = 'Shipping Agents - Calendar Setup';
    UsageCategory = Administration;
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Shipping Agent";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            field(PTECalendarBackground; Rec.PTECalendarBackground)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Calendar Background Colour for this resource.';
            }

            usercontrol(FldColorPicker; PTEColorPicker)
            {
                ApplicationArea = All;

                trigger ControlReady()
                begin
                    CurrPage.FldColorPicker.Init();
                    CurrPage.FldColorPicker.SetColour(Rec.PTECalendarBackground);
                    ControlReady := true;
                end;
            }

            field(PTEOpeningTime; Rec.PTEOpeningTime)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Calendar Business Opening Time for this resource.';
            }

            field(PTEClosingTime; Rec.PTEClosingTime)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Calendar Business Closing Time for this resource.';
            }

            field(PTEDays; Rec.PTEDays)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Calendar Business Days for this resource.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetColour();
    end;

    var
        ControlReady: Boolean;


    /// <summary>
    /// SetColour.
    /// </summary>
    local procedure SetColour()
    begin
        if not ControlReady then
            exit;

        CurrPage.FldColorPicker.SetColour(Rec.PTECalendarBackground);
    end;
}
