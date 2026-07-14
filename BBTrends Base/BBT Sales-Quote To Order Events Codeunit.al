codeunit 50026 "Sales-Quote To Order Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderHeader', '', false, false)]
    local procedure OnBeforeInsertSalesOrderHeader(var SalesOrderHeader: Record "Sales Header"; var SalesQuoteHeader: Record "Sales Header")
    begin
        //>> BTT 17/02/2022
        SalesOrderHeader."Reason Code" := '';
        //<<
    end;
}
