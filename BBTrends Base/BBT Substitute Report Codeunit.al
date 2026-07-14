codeunit 50049 "Substitute Report"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        //Los comentados, es porque no existe ese report estándar en BC o está marcado como eliminar
        case ReportId of
            Report::"Calculate Inventory":
                NewReportId := Report::"BBT Calculate Inventory";
            // Report::"Change Log - Delete":
            //     NewReportId := Report::"BBT Change Log - Delete";
            Report::"Exchange Production BOM Item":
                NewReportId := Report::"BBT Exch. Production BOM Item";
            Report::"Get Source Documents":
                NewReportId := Report::"BBT Get Source Documents";
            Report::"Inventory Availability":
                NewReportId := Report::"BBT Inventory Availability";
            //>> BBT. SDA
            //Report::"Inventory - Availability Plan": NewReportId:=Report::"BBT Inv. - Availability Plan";
            //<<
            // Report::"Order Confirmation":
            //    NewReportId := Report::"BBT Order Confirmation";
            Report::"Purchase - Receipt":
                NewReportId := Report::"BBT Purchase - Receipt";
            Report::"Purchases Invoice Book":
                NewReportId := Report::"BBT Purchases Invoice Book";
            Report::"Refresh Production Order":
                NewReportId := Report::"BBT Refresh Production Order";
            // Report::"Sales - Quote":
            //     NewReportId := Report::"BBT Sales - Quote";
            //ini - Da error de compilación
            // Report::"Transfer Order":
            //     NewReportId := Report::"BBT Transfer Order";
            //fin - Da error de compilación
            Report::"Whse. - Shipment":
                NewReportId := Report::"BBT Whse. - Shipment";
        end;
    end;
}
