pageextension 50202 PTECustomerDemo2 extends "Customer Card"
{

    layout
    {
        addlast(FactBoxes)
        {
            part(CalendarJsPart; PTECalendarJsPart)
            {
                ApplicationArea = All;
                Caption = 'Calendar';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.CalendarJsPart.Page.InitCalendarSource(Database::Customer, Rec.SystemId, true);
    end;
}
