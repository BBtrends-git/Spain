PageExtension 51457 "SGA Warehouse Shipment List" extends "Warehouse Shipment List"
{
    layout
    {
        addafter(Status)
        {
            field("SGA Status"; Rec."SGA Status")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
        }
        addafter("Shipment Method Code")
        {
            field("SGA Destination Type"; Rec."SGA Destination Type")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
            field("SGA Destination No."; Rec."SGA Destination No.")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
            field(SGADestinantionName; DestinationName)
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
                Caption = 'Destination Name', Comment = 'ESP="Nombre Destino"';
            }
            field("SGA Source No."; Rec."SGA Source No.")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
            field(SGASourceExternalDoc; SourceExternalDoc)
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
                Caption = 'Source External Document', Comment = 'ESP="Documento Externo"';
            }
        }
    }

    var
        cuSGAManagement: Codeunit "SGA Management";
        SGAEnabled: Boolean;

    trigger OnOpenPage()
    begin
        SGAEnabled := cuSGAManagement.IsSGAEnabled();

        //>> Quitar una vez ejecutado en producción
        /*
        if SGAEnabled then
            SGAModifyConditions();
        */
    end;

    //>> Quitar una vez ejecutado en producción
    /*
    local procedure SGAModifyConditions();
    var
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        rWarehouseShipmentHeader.Reset();
        if rWarehouseShipmentHeader.FindSet() then
            repeat
                rWarehouseShipmentHeader."SGA Status" := rWarehouseShipmentHeader."Status SGA";
                rWarehouseShipmentHeader."SGA Readed" := rWarehouseShipmentHeader."Leido SGA";
                rWarehouseShipmentHeader."SGA Inserted" := rWarehouseShipmentHeader."Grabado SGA";
                rWarehouseShipmentHeader."SGA Destination Type" := rWarehouseShipmentHeader."Destination Type";
                rWarehouseShipmentHeader."SGA Source No." := rWarehouseShipmentHeader."Destination No.";
                rWarehouseShipmentHeader.Modify();
            until rWarehouseShipmentHeader.Next() = 0;
    end;
    */
    //<<

    trigger OnAfterGetRecord()
    var
        rSGABlockedDocuments: Record "SGA Blocked Documents";
    begin
        // Si el TWO ya no lo tiene bloqueado lo modificamos.
        if SGAEnabled and (Rec."SGA Status" = rec."SGA Status"::"SGA Locked") then begin
            rSGABlockedDocuments.Reset();
            if not rSGABlockedDocuments.Get(rSGABlockedDocuments."SGA Document Type"::Sales, Rec."No.") then begin
                Rec."SGA Status" := Rec."SGA Status"::"SGA Sent";
                Rec.Modify();
            end;
        end;
    end;

    local procedure DestinationName(): Text[50]
    var
        rCustomer: Record Customer;
        rVendor: Record Vendor;
    begin
        case Rec."SGA Destination Type" of
            Rec."SGA Destination Type"::Customer:
                begin
                    rCustomer.Get(Rec."SGA Destination No.");
                    exit(rCustomer.Name);
                end;
            Rec."SGA Destination Type"::Vendor:
                begin
                    rVendor.Get(Rec."SGA Destination No.");
                    exit(rVendor.Name);
                end;
            else
                exit('');
        end;
    end;

    local procedure SourceExternalDoc(): Text[50]
    var
        rSalesHeader: Record "Sales Header";
    begin
        case Rec."SGA Destination Type" of
            Rec."SGA destination type"::Customer:
                begin
                    rSalesHeader.Reset;
                    rSalesHeader.SetRange("Document Type", rSalesHeader."document type"::Order);
                    rSalesHeader.SetRange("No.", Rec."SGA Source No.");
                    if rSalesHeader.FindFirst then
                        exit(rSalesHeader."External Document No.")
                    else
                        exit('');
                end;
            else
                exit('');
        end;
    end;
}
