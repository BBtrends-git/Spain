codeunit 50039 "Get Source Documents Events"
{
    [EventSubscriber(ObjectType::report, report::"Get Source Documents", 'OnSalesLineOnAfterCreateShptHeader', '', false, false)]
    local procedure OnSalesLineOnAfterCreateShptHeader(var WhseShptHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line"; WhseHeaderCreated: Boolean; SalesHeader: Record "Sales Header"; WarehouseRequest: Record "Warehouse Request")
    var
        CompanyInformation: Record "Company Information";
    begin
        //IF CompanyInformation.get and CompanyInformation.SGA THEN
        MeterComentariosPedido(WhseShptHeader, SalesLine);

        if SalesHeader."No." = '' then begin
            clear(WhseShptHeader."External Document No.");
            clear(WhseShptHeader."Shipment Method Code");
            clear(WhseShptHeader."Shipping Agent Code");
            clear(WhseShptHeader."Shipping Agent Service Code");
        end
        else begin
            WhseShptHeader."Shipping Agent Code" := SalesHeader."Shipping Agent Code";
            WhseShptHeader."Shipment Date" := SalesHeader."Requested Delivery Date";
            WhseShptHeader."Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
            WhseShptHeader."Shipment Method Code" := SalesHeader."Shipment Method Code";
            clear(WhseShptHeader."External Document No.");
            WhseShptHeader.Modify();
        end;
    end;

    local procedure MeterComentariosPedido(_WhseShpHeader: Record "Warehouse Shipment Header"; _Salesline: Record "Sales Line")
    var
        _SalesComent: Record "Sales Comment Line";
        _ShippingComment: Record "Warehouse Comment Line";
        _NumLineaComent: Integer;
    begin
        _SalesComent.SetRange("Document Type", _SalesComent."document type"::Order);
        _SalesComent.SetRange("No.", _Salesline."Document No.");
        _SalesComent.SetRange("Comment type", _SalesComent."comment type"::Ship);
        if _SalesComent.FindSet then begin
            _ShippingComment.SetRange("Table Name", _ShippingComment."table name"::"Whse. Shipment");
            _ShippingComment.SetRange(Type, _ShippingComment.Type::" ");
            _ShippingComment.SetRange("No.", _WhseShpHeader."No.");
            if _ShippingComment.FindLast then
                _NumLineaComent := _ShippingComment."Line No."
            else
                _NumLineaComent := 0;
            _ShippingComment.Reset;
            repeat
                _NumLineaComent += 10000;
                _ShippingComment.Init;
                _ShippingComment."Table Name" := _ShippingComment."table name"::"Whse. Shipment";
                _ShippingComment.Type := _ShippingComment.Type::" ";
                _ShippingComment."No." := _WhseShpHeader."No.";
                _ShippingComment."Line No." := _NumLineaComent;
                _ShippingComment.Date := _SalesComent.Date;
                _ShippingComment.Code := _SalesComent.Code;
                _ShippingComment.Comment := _SalesComent.Comment;
                _ShippingComment.Insert;
            until _SalesComent.Next = 0;
        end;
    end;
}
