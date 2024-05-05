page 50206 PTECalendarJsSearchOptions
{
    Caption = 'PTECalendarJsSearchOptions';
    PageType = Card;
    SourceTable = PTECalendarJsSearchOption;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Options';

                field(UseNot; Rec.UseNot)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the search should be a not search (defaults to false).';
                }
                field(MatchCase; Rec.MatchCase)
                {
                    ApplicationArea = All;
                    ToolTip = 'States character case searching is strict (defaults to false).';
                }
                field(ShowAdvanced; Rec.ShowAdvanced)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the advanced options should be shown (defaults to false).';
                }
                field(SearchTitle; Rec.SearchTitle)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the "title" property for the event should be searched (false to true).';
                }
                field(SearchLocation; Rec.SearchLocation)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the "location" property for the event should be searched (false to false).';
                }
                field(SearchDescription; Rec.SearchDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the "description" property for the event should be searched (false to false).';
                }
                field(SearchGroup; Rec.SearchGroup)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the "group" property for the event should be searched (false to false).';
                }
                field(SearchUrl; Rec.SearchUrl)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the "url" property for the event should be searched (false to false).';
                }
                field(StartsWith; Rec.StartsWith)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the search should run a “starts with” check (defaults to false).';
                }
                field(EndsWith; Rec.EndsWith)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the search should run a “ends with” check (defaults to false).';
                }
                field(UseContains; Rec.UseContains)
                {
                    ApplicationArea = All;
                    ToolTip = 'States if the search should run a “contains with” check (defaults to true).';
                }
            }
        }
    }
}
