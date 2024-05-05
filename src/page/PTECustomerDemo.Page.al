page 50213 PTECustomerDemo
{
    ApplicationArea = All;
    Caption = 'Customer Demo';
    PageType = Card;
    SourceTable = Customer;
    UsageCategory = Administration;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
            }
            part(CalendarJsPart; PTECalendarJsPart)
            {
                ApplicationArea = All;
                Caption = 'Calendar';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.CalendarJsPart.Page.InitCalendarSource(Database::Customer, Rec.SystemId, false);
    end;
}
