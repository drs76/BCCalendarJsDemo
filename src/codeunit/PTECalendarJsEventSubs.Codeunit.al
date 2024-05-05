codeunit 50207 PTECalendarJsEventSubs
{
    [EventSubscriber(ObjectType::Table, Database::PTECalendarJsEvent, 'OnAfterInsertEvent', '', true, false)]
    local procedure PTECalendarJsEvent_OnAfterInsertEvent(var Rec: Record PTECalendarJsEvent; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary() then
            exit;

        if IsNullGuid(Rec.Id) then
            Rec.Id := Rec.SystemId;
    end;

}
