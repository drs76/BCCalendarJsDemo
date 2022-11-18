/// <summary>
/// PageExtension PTESalesOrder (ID 50100) extends Record Sales Order.
/// </summary>
pageextension 50148 PTESalesOrder extends "Sales Order"
{
    layout
    {
        addafter("Shipment Date")
        {
            group(PTEDeliverySlot)
            {
                Caption = 'Delivery Slot';

                field(PTEDeliverySlotAllDay; Rec.PTEDeliverySlotAllDay)
                {
                    ToolTip = 'Specifies if the delivery slot is all day.';
                    ApplicationArea = All;
                }

                field(PTEDeliverySlotStart; Rec.PTEDeliverySlotStart)
                {
                    ToolTip = 'Specifies the delivery slot start time.';
                    ApplicationArea = All;
                }

                field(PTEDeliverySlotEnd; Rec.PTEDeliverySlotEnd)
                {
                    ToolTip = 'Specifies the delivery slot end time.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
