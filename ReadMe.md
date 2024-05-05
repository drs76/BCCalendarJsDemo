# Business Central CalendarJs Demo

Demo of using Calendar.js in BC User Control.

Calendar used for controladdin

[Calender.js](https://github.com/williamtroup/Calendar.js)

[Documentation Calendar.js](https://calendar-js.com/index.html)

## Functionality

Add, Edit and Delete events, drag and drop events, resize events.

CalendarJs Setup, Search and View Options can be saved in BC and applied to the Calendar.

Events are stored within PTECalendarEvent table in Business Central.

There are 5 slots for KeyData to use for filtering, record systemId and table no.

Calendar can be used as a page part, or a factboc (widget)

Add the PTECalendarJSPart to a page and add the following code to the OnAfterGetCurrRecord

PagePart example:

```
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
```

Factbox as widget example:

```
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
```

## Calendar

![Alt text](/images/CalendarJsSetup.png?raw=true "Calendar Setup")

![Alt text](/images/CustomerDemoCalendar.png?raw=true "Calendar Month")

![Alt text](/images/CustomerDemoCalendarFullWeek.png?raw=true "Calendar FullWeek")

![Alt text](/images/CustomerDemoCalendarFullDay.png?raw=true "Calendar FullDay")

![Alt text](/images/CustomerDemoCalendarTimeLine.png?raw=true "Calendar Timeline")

![Alt text](/images/CustomerDemoCalendarAllYear.png?raw=true "Calendar AllYear")

![Alt text](/images/CustomerDemoCalendarAllEvents.png?raw=true "Calendar AllEvents")
![Alt text](/images/CustomerDemoCalendarAllEvents.png?raw=true "Calendar AllEvents")
![Alt text](/images/CustomerDemoCalendarAllEvents.png?raw=true "Calendar AllEvents")

### Add Event

![Alt text](/images/CalendarAddEventEvent.png?raw=true "Calendar Add Event Event")

![Alt text](/images/CalendarAddEventType.png?raw=true "Calendar Add Event Type")

![Alt text](/images/CalendarAddEventRepeats.png?raw=true "Calendar Add Event Repeats")

![Alt text](/images/CalendarAddEventOptional.png?raw=true "Calendar Add Event Option")

![Alt text](/images/CalendarAddEventColours.png?raw=true "Calendar Add Event Colours")

### As widget

![Alt text](/images/CustomerDemoCalendarWidget.png?raw=true "Calendar As Widget")

### Author: Dave Sinclair (2024)
