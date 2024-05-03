permissionset 50200 BCCalendarJsDemo
{
    Caption = 'BCCalendarJS';
    Assignable = true;
    Permissions = codeunit PTEFullCalendarEventMgt = X,
        codeunit PTECalendarJsHelper = X,
        codeunit PTECalendarJsJsonHelper = X,
        page PTECalendarDemo = X,
        page PTEFullCalendarEvent = X,
        tabledata PTECalendarJsSetup = RIMD,
        table PTECalendarJsSetup = X,
        codeunit PTEFullCalendarSetupMgt = X,
        tabledata PTECalendarJsViewOption = RIMD,
        table PTECalendarJsViewOption = X,
        tabledata PTECalendarJsSearchOption = RIMD,
        table PTECalendarJsSearchOption = X,
        page PTECalendarJsSetup = X,
        page PTECalendarJSViewOptions = X,
        tabledata PTECalendarJsTranslations = RIMD,
        table PTECalendarJsTranslations = X,
        page PTECalendarJsSearchOptions = X,
        page PTECalendarJsSetups = X,
        page PTECalendarJsTranslationLegend = X,
        page PTECalendarJSViewOption = X,
        page PTESelectFromEnumValues = X;
}