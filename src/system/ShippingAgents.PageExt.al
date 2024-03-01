/// <summary>
/// PageExtension PTEShippingAgents (ID 50100) extends Record Shipping Agents.
/// </summary>
pageextension 50201 PTEShippingAgents extends "Shipping Agents"
{
    actions
    {
        addafter(ShippingAgentServices)
        {
            action(PTECalendarSetup)
            {
                ApplicationArea = All;
                Caption = 'Calendar Setup';
                ToolTip = 'Specifies the setup fields for the Calendar';
                Image = Calendar;

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    Commit();

                    Page.Run(Page::PTEShippingAgentsCalendarInfo, Rec);
                end;
            }
        }
    }
}
