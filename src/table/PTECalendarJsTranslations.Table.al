table 50203 PTECalendarJsTranslations
{
    Caption = 'CalendarJs Translations';
    DataClassification = CustomerContent;

    fields
    {
        field(1; CalendarCode; Code[20])
        {
            Caption = 'CalendarCode';
            Editable = false;
        }
        field(2; TranslationType; Code[50])
        {
            Caption = 'TranslationType';
            Editable = false;
        }
        field(3; TranslationCode; Text[50])
        {
            Caption = 'TranslationCode';

            trigger OnValidate()
            begin
                Rec.TranslationType := Rec.TranslationCode;
            end;

            trigger OnLookup()
            var
                CalendarJsTranslations: Page PTECalendarJsTranslationLegend;
            begin
                CalendarJsTranslations.LookupMode(true);
                if CalendarJsTranslations.RunModal() <> Action::LookupOK then
                    exit;

                Rec.Validate(TranslationCode, CalendarJsTranslations.GetSelection());
            end;
        }
        field(4; Translation; Text[2048])
        {
            Caption = 'Translation';
        }
    }

    keys
    {
        key(PK; CalendarCode, TranslationType)
        {
            Clustered = true;
        }
    }
}
