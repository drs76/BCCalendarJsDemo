page 50213 PTECustomerDemo
{
    ApplicationArea = All;
    Caption = 'CalendarJs Customer Demo';
    AdditionalSearchTerms = 'Calendar,Customer';
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
            part(CalendarJsPart; PTECalendarJsPart)
            {
                ApplicationArea = All;
                Caption = 'Calendar';
            }
        }
    }

    var
        CurrCus: RecordId;

    trigger OnAfterGetCurrRecord()
    begin
        if CurrCus <> Rec.RecordId() then
            CurrPage.CalendarJsPart.Page.InitCalendarSource(Database::Customer, Rec.SystemId, false);
    end;
}
