/// <summary>
/// TableExtension PTEShippingAgent (ID 50100) extends Record Shipping Agent.
/// </summary>
tableextension 50201 PTEShippingAgent extends "Shipping Agent"
{
    fields
    {
        field(50100; PTECalendarBackground; Text[30])
        {
            Caption = 'Calendar Background';
            DataClassification = CustomerContent;
        }
        field(50101; PTEOpeningTime; Time)
        {
            Caption = 'Business Opening Time';
            DataClassification = CustomerContent;
        }
        field(50102; PTEClosingTime; Time)
        {
            Caption = 'Business Closing Time';
            DataClassification = CustomerContent;
        }
        field(50103; PTEDays; Text[30])
        {
            Caption = 'Business Days';
            DataClassification = CustomerContent;
        }

    }
}
