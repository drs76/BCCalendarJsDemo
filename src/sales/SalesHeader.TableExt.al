/// <summary>
/// TableExtension PTESalesHeader (ID 50101) extends Record Sales Header.
/// </summary>
tableextension 50200 PTESalesHeader extends "Sales Header"
{
    fields
    {
        field(50100; PTEDeliverySlotStart; Time)
        {
            Caption = 'Delivery Slot Start';
            DataClassification = CustomerContent;
        }

        field(50101; PTEDeliverySlotEnd; Time)
        {
            Caption = 'Delivery Slot End';
            DataClassification = CustomerContent;
        }

        field(50102; PTEDeliverySlotAllDay; Boolean)
        {
            Caption = 'Delivery Slot All Day';
            DataClassification = CustomerContent;
        }
    }
}
