pageextension 50202 PTECustomerDemo2 extends "Customer Card"
{

    layout
    {
        addlast(FactBoxes)
        {
            part(CalendarJsPart; PTECalendarJsPart)
            {
                ApplicationArea = All;
                Caption = 'Calendar Day';
            }
            part(CalendarJsPartFull; PTECalendarJsPart)
            {
                ApplicationArea = All;
                Caption = 'Calendar Full';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.CalendarJsPart.Page.InitCalendarSource(Database::Customer, Rec.SystemId, true);
        CurrPage.CalendarJsPartFull.Page.InitCalendarSource(Database::Customer, Rec.SystemId, false);
    end;
}
