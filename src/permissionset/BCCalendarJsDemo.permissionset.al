permissionset 50200 BCCalendarJsDemo
{
    Caption = 'BCCalendarJsDemo';
    Assignable = true;
    Permissions = codeunit PTECalendarJsHelper = X,
        codeunit PTECalendarJsJsonHelper = X,
        page PTECalendarJsPart = X,
        tabledata PTECalendarJsSetup = RIMD,
        table PTECalendarJsSetup = X,
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
        page PTESelectFromEnumValues = X,
        page PTECalendarJsTranslatons = X,
        tabledata PTECalendarJsEvent = RIMD,
        table PTECalendarJsEvent = X;
}