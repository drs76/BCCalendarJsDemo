page 50211 PTECalendarJsTranslatons
{
    ApplicationArea = All;
    Caption = 'CalendarJs Translatons';
    PageType = List;
    UsageCategory = None;
    SourceTable = PTECalendarJsTranslations;
    DelayedInsert = true;
    LinksAllowed = false;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(CalendarCode; Rec.CalendarCode)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Calendar Code field.';
                }
                field(TranslationCode; Rec.TranslationCode)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Translation Code field.';

                    trigger OnValidate()
                    begin
                        Rec.TestField(Rec.TranslationCode);
                    end;
                }
                field(Translation; Rec.Translation)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Translation field.';

                    trigger OnValidate()
                    begin
                        Rec.TestField(Rec.Translation);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Legend)
            {
                ApplicationArea = All;
                Caption = 'Legend';
                ToolTip = 'Display Legend of available Translation Codes.';
                Image = Language;

                RunObject = page PTECalendarJsTranslationLegend;
            }
        }
        area(Promoted)
        {
            actionref(LegendPromoted; Legend)
            {
            }
        }
    }
}
