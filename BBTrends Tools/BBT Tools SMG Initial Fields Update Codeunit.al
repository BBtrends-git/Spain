Codeunit 59005 "SMG Initial Fields Update"
{
    Permissions = tableData "Item" = rimd,
                    tabledata "Customer" = rimd,
                    tabledata "Sales Header" = rimd,
                    tabledata "Sales Line" = rimd,
                    tabledata "Sales Shipment Line" = rimd,
                    tabledata "Sales Invoice Line" = rimd,
                    tabledata "Sales Cr.Memo Line" = rimd;

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        case Rec."Parameter String" of

            'CLASSIFICATIONS':
                begin
                    FieldsUpdateCustomerClassifications();
                    Commit();
                end;
            'CUSTOMERS':
                begin
                    FieldsUpdateCustomers();
                    Commit();
                end;
            'APOSPLATAFORMA':
                begin
                    FieldsUpdateAPOsPlataforma();
                    Commit();
                end;
            'ITEMS':
                begin
                    FieldsUpdateItems();
                    Commit();
                end;
            'SALESHEADERS':
                begin
                    FieldsUpdateSalesHeader();
                    Commit();
                end;
            'SALESLINES':
                begin
                    FieldsUpdateSalesLine();
                    Commit();
                end;
            'SALESMARGIN':
                begin
                    FieldsUpdateSalesMargin();
                    Commit();
                end;
            'SHIPMENTLINES':
                begin
                    FieldsUpdateSalesShipmentLine();
                    Commit();
                end;
            'INVOICELINES':
                begin
                    FieldsUpdateSalesInvoiceLine();
                    Commit();
                end;
            'CREDITMEMOLINES':
                begin
                    ;
                    FieldsUpdateSalesCreditMemoLine();
                    Commit();
                end;
            else
                Error('Parámetro no reconocido: ' + Rec."Parameter String");

        end;
    end;

    Procedure FieldsUpdateCustomerClassifications();
    var
        rPurchaseGroup: Record "Purchase Group";
        rCustomerClassification: Record "Customer Classification";
        RSMGCustomerClassification: Record "SMG Customer Classification";
    begin
        // Se borra la tabla de Clasificación
        if RSMGCustomerClassification.FindSet() then
            RSMGCustomerClassification.DeleteAll;

        rPurchaseGroup.Reset();
        if rPurchaseGroup.FindSet() then
            repeat
            begin
                Clear(RSMGCustomerClassification);
                RSMGCustomerClassification.Init();
                RSMGCustomerClassification.Type := RSMGCustomerClassification.Type::"Purchasing Group";
                RSMGCustomerClassification.Code := rPurchaseGroup.Code;
                RSMGCustomerClassification.Description := rPurchaseGroup.Description;
                RSMGCustomerClassification.Insert();
            end;
            until rPurchaseGroup.Next() = 0;

        rCustomerClassification.Reset();
        rCustomerClassification.SetRange(Type, rCustomerClassification.Type::"Customer Type");
        if rCustomerClassification.FindSet() then
            repeat
            begin
                Clear(RSMGCustomerClassification);
                RSMGCustomerClassification.Init();
                RSMGCustomerClassification.Type := RSMGCustomerClassification.Type::"Customer Type";
                RSMGCustomerClassification.Code := rCustomerClassification.Code;
                RSMGCustomerClassification.Description := rCustomerClassification.Description;
                RSMGCustomerClassification.Insert();
            end;
            until rCustomerClassification.Next() = 0;

        rCustomerClassification.Reset();
        rCustomerClassification.SetRange(Type, rCustomerClassification.Type::"National Group");
        if rCustomerClassification.FindSet() then
            repeat
            begin
                Clear(RSMGCustomerClassification);
                RSMGCustomerClassification.Init();
                RSMGCustomerClassification.Type := RSMGCustomerClassification.Type::"National Group";
                RSMGCustomerClassification.Code := rCustomerClassification.Code;
                RSMGCustomerClassification.Description := rCustomerClassification.Description;
                RSMGCustomerClassification.Insert();
            end;
            until rCustomerClassification.Next() = 0;

        rCustomerClassification.Reset();
        rCustomerClassification.SetRange(Type, rCustomerClassification.Type::"Platform");
        if rCustomerClassification.FindSet() then
            repeat
            begin
                Clear(RSMGCustomerClassification);
                RSMGCustomerClassification.Init();
                RSMGCustomerClassification.Type := RSMGCustomerClassification.Type::"Platform";
                RSMGCustomerClassification.Code := rCustomerClassification.Code;
                RSMGCustomerClassification.Description := rCustomerClassification.Description;
                RSMGCustomerClassification.Insert();
            end;
            until rCustomerClassification.Next() = 0;
    end;

    procedure FieldsUpdateCustomers()
    var
        rCustomer: Record Customer;
        rCondAPOs: Record "Cond APos";
        rSalesDiscounts: Record "Sales Discounts";
        rSMGColsConditions: Record "SMG COLS Conditions";
        rSMGAPOsConditions: Record "SMG APOS Conditions";
        rSMGSalesDiscounts: Record "SMG Sales Discounts";
    begin
        // Se borra la tabla de COLs
        if rSMGColsConditions.FindSet() then
            rSMGColsConditions.DeleteAll();
        // Se borran de la tabla los APOs de Cliente
        rSMGAPOsConditions.SetRange("Condition Classification", rSMGAPOsConditions."Condition Classification"::Customer);
        if rSMGAPOsConditions.FindSet() then
            repeat
                rSMGAPOsConditions.Delete();
            until rSMGAPOsConditions.Next() = 0;
        // Se borra la tabla de descuentos. En teoría solo hay dtos de cliente.
        if rSMGSalesDiscounts.FindSet() then
            rSMGSalesDiscounts.DeleteAll();

        rCustomer.Reset();
        if rCustomer.FindSet() then
            repeat begin
                rCustomer."SMG Commission %" := rCustomer."Comission %";
                rCustomer."SMG Devs Fin %" := rCustomer."DEVS  FIN %";
                rCustomer."SMG Transport Sales %" := rCustomer."Transporte ventas %";
                rCustomer."SMG No Apply RAEE" := rCustomer."No Apply RAEE";

                rCustomer."SMG Purchase Group" := rCustomer."Purchase Group";
                rCustomer."SMG Customer Type" := rCustomer."Customer Type";
                rCustomer."SMG National Group" := rCustomer."National Group";
                rCustomer."SMG Platform" := rCustomer.Platform;

                rCustomer.Modify();

                // --------------------------- COLs -----------------------
                // COLs 2024
                if rCustomer."Condiciones F.F. % COLs 2024" <> 0 then begin
                    Clear(rSMGColsConditions);
                    rSMGColsConditions.Init();
                    rSMGColsConditions."Customer No." := rCustomer."No.";
                    rSMGColsConditions."Starting Date" := DMY2Date(01, 01, 2024);
                    rSMGColsConditions."Ending Date" := DMY2Date(31, 12, 2024);
                    rSMGColsConditions."% COLS Excluded from Invoice" := rCustomer."Condiciones F.F. % COLs 2024";
                    rSMGColsConditions.Insert();
                end;

                // COLs 2025
                if rCustomer."Condiciones F.F. % COLs 2025" <> 0 then begin
                    Clear(rSMGColsConditions);
                    rSMGColsConditions.Init();
                    rSMGColsConditions."Customer No." := rCustomer."No.";
                    rSMGColsConditions."Starting Date" := DMY2Date(01, 01, 2025);
                    rSMGColsConditions."Ending Date" := DMY2Date(31, 12, 2025);
                    rSMGColsConditions."% COLS Excluded from Invoice" := rCustomer."Condiciones F.F. % COLs 2025";
                    rSMGColsConditions.Insert();
                    Commit();
                end;

                // COLs 2026
                if rCustomer."Condiciones fuera fact. % COLS" <> 0 then begin
                    Clear(rSMGColsConditions);
                    rSMGColsConditions.Init();
                    rSMGColsConditions."Customer No." := rCustomer."No.";
                    rSMGColsConditions."Starting Date" := DMY2Date(01, 01, 2026);
                    //rSMGColsConditions."Ending Date" := DMY2Date(31, 12, 2026);
                    rSMGColsConditions."% COLS Excluded from Invoice" := rCustomer."Condiciones fuera fact. % COLS";
                    rSMGColsConditions.Insert();
                    Commit();
                end;

                // -------------------- APOs Cliente ----------------------
                // APOs 2024

                if rCustomer."Condiciones F.F. % APOs 2024" <> 0 then begin
                    Clear(rSMGAPOsConditions);
                    rSMGAPOsConditions.Init();
                    rSMGAPOsConditions."Condition Classification" := rSMGAPOsConditions."Condition Classification"::Customer;
                    rSMGAPOsConditions."Condition Code" := rCustomer."No.";
                    rSMGAPOsConditions."Starting Date" := DMY2Date(01, 01, 2024);
                    rSMGAPOsConditions."Ending Date" := DMY2Date(31, 12, 2024);
                    rSMGAPOsConditions."% APOS Excluded from Invoice" := rCustomer."Condiciones F.F. % APOs 2024";
                    rSMGAPOsConditions.Insert();
                end;

                // APOs 2025
                if rCustomer."Condiciones F.F. % APOs 2025" <> 0 then begin
                    Clear(rSMGAPOsConditions);
                    rSMGAPOsConditions.Init();
                    rSMGAPOsConditions."Condition Classification" := rSMGAPOsConditions."Condition Classification"::Customer;
                    rSMGAPOsConditions."Condition Code" := rCustomer."No.";
                    rSMGAPOsConditions."Starting Date" := DMY2Date(01, 01, 2025);
                    rSMGAPOsConditions."Ending Date" := DMY2Date(31, 12, 2025);
                    rSMGAPOsConditions."% APOS Excluded from Invoice" := rCustomer."Condiciones F.F. % APOs 2025";
                    rSMGAPOsConditions.Insert();
                end;


                // APOs 2026
                // Sin MARCA
                rCondAPOs.Reset();
                rCondAPOs.SetRange(Plataforma, false);
                rCondAPOs.SetRange(Code, rCustomer."No.");
                rcondAPOs.SetFilter("Global Dimension 2 Code", '=%1', '');
                if rCondAPOs.FindSet() then
                    repeat
                        Clear(rSMGAPOsConditions);
                        rSMGAPOsConditions.Init();
                        rSMGAPOsConditions."Condition Classification" := rSMGAPOsConditions."Condition Classification"::Customer;
                        rSMGAPOsConditions."Condition Code" := rCondAPOs.Code;
                        rSMGAPOsConditions.Description := rCondAPOs."APOs Comment";
                        rSMGAPOsConditions."% APOS Excluded from Invoice" := rCondAPOs."Condiciones fuera fact. % APOS";
                        rSMGAPOsConditions."Starting Date" := DMY2Date(01, 01, 2026);
                        //rSMGAPOsConditions."Ending Date" := DMY2Date(31,12,2026);
                        rSMGAPOsConditions.Insert();
                    until rCondAPOs.Next() = 0;

                // Marca UFESA
                rCondAPOs.Reset();
                rCondAPOs.SetRange(Plataforma, false);
                rCondAPOs.SetRange(Code, rCustomer."No.");
                rcondAPOs.SetFilter(rCondApos."Global Dimension 2 Code", '=%1', 'UFESA');
                if rCondAPOs.FindSet() then
                    repeat
                        Clear(rSMGAPOsConditions);
                        rSMGAPOsConditions.Init();
                        rSMGAPOsConditions."Condition Classification" := rSMGAPOsConditions."Condition Classification"::Customer;
                        rSMGAPOsConditions."Condition Code" := rCondAPOs.Code;
                        rSMGAPOsConditions.Description := rCondAPOs."APOs Comment";
                        rSMGAPOsConditions."% APOS Excluded from Invoice" := rCondAPOs."Condiciones fuera fact. % APOS";
                        rSMGAPOsConditions."Starting Date" := DMY2Date(01, 01, 2026);
                        //rSMGAPOsConditions."Ending Date" := DMY2Date(31,12,2026);
                        if rCondAPOs."APOs Comment" = '' then
                            rSMGAPOsConditions.Description := 'Marca UFESA';
                        rSMGAPOsConditions.Insert();
                    until rCondAPOs.Next() = 0;
                // Marca ZELMER
                rCondAPOs.Reset();
                rCondAPOs.SetRange(Plataforma, false);
                rCondAPOs.SetRange(Code, rCustomer."No.");
                rcondAPOs.SetFilter(rCondApos."Global Dimension 2 Code", '=%1', 'ZELMER');
                if rCondAPOs.FindSet() then
                    repeat
                        Clear(rSMGAPOsConditions);
                        rSMGAPOsConditions.Init();
                        rSMGAPOsConditions."Condition Classification" := rSMGAPOsConditions."Condition Classification"::Customer;
                        rSMGAPOsConditions."Condition Code" := rCondAPOs.Code;
                        rSMGAPOsConditions.Description := rCondAPOs."APOs Comment";
                        rSMGAPOsConditions."% APOS Excluded from Invoice" := rCondAPOs."Condiciones fuera fact. % APOS";
                        rSMGAPOsConditions."Starting Date" := DMY2Date(01, 01, 2026);
                        //rSMGAPOsConditions."Ending Date" := DMY2Date(31,12,2026);
                        if rCondAPOs."APOs Comment" = '' then
                            rSMGAPOsConditions.Description := 'Marca ZELMER';
                        rSMGAPOsConditions.Insert();
                    until rCondAPOs.Next() = 0;

                // --------------------- DTOS de Cliente -----------------

                rSalesDiscounts.Reset();
                rSalesDiscounts.SetRange("Apply to", rSalesDiscounts."Apply to"::Customer);
                //rSalesDiscounts.SetRange(Code, format('C01109'));
                rSalesDiscounts.SetRange(Code, rCustomer."No.");
                if rSalesDiscounts.FindSet() then
                    repeat
                    begin
                        if (rSalesDiscounts."Discount 1 %" <> 0) or
                            (rSalesDiscounts."Discount 2 %" <> 0) or
                            (rSalesDiscounts."Discount 3 %" <> 0) or
                            (rSalesDiscounts."Discount 4 %" <> 0) or
                            (rSalesDiscounts."Discount 5 %" <> 0) then begin
                            clear(rSMGSalesDiscounts);
                            rSMGSalesDiscounts.Init();
                            rSMGSalesDiscounts."SMG Apply to" := rSMGSalesDiscounts."SMG Apply to"::Customer;
                            rSMGSalesDiscounts."SMG Code" := rSalesDiscounts.Code;
                            rSMGSalesDiscounts."SMG Discount 1 %" := rSalesDiscounts."Discount 1 %";
                            rSMGSalesDiscounts."SMG Discount 2 %" := rSalesDiscounts."Discount 2 %";
                            rSMGSalesDiscounts."SMG Discount 3 %" := rSalesDiscounts."Discount 3 %";
                            rSMGSalesDiscounts."SMG Discount 4 %" := rSalesDiscounts."Discount 4 %";
                            rSMGSalesDiscounts."SMG Discount 5 %" := rSalesDiscounts."Discount 5 %";
                            rSMGSalesDiscounts.Insert();
                        end;
                    end;
                    until rSalesDiscounts.Next() = 0;
            end;
            until rCustomer.Next() = 0;
    end;

    procedure FieldsUpdateAPOsPlataforma();
    var
        rCondAPOs: Record "Cond APos";
        rSMGAPOsConditions: Record "SMG APOS Conditions";
    begin
        // Borramos las APOs de Plataforma
        rSMGAPOsConditions.Reset();
        rSMGAPOsConditions.SetRange("Condition Classification", rSMGAPOsConditions."Condition Classification"::Platform);
        if rSMGAPOsConditions.FindSet() then
            repeat
                rSMGAPOsConditions.Delete();
            until rSMGAPOsConditions.Next() = 0;

        rCondAPOs.Reset();
        rCondAPOs.SetRange(Plataforma, true);
        if rCondAPOs.FindSet() then
            repeat
                Clear(rSMGAPOsConditions);
                rSMGAPOsConditions.Init();
                rSMGAPOsConditions."Condition Classification" := rSMGAPOsConditions."Condition Classification"::Platform;
                rSMGAPOsConditions."Condition Code" := rCondAPOs.Code;
                rSMGAPOsConditions.Description := rCondAPOs."APOs Comment";
                rSMGAPOsConditions."% APOS Excluded from Invoice" := rCondAPOs."Condiciones fuera fact. % APOS";
                rSMGAPOsConditions."Starting Date" := DMY2Date(01, 01, 2026);
                //rSMGAPOsConditions."Ending Date" := DMY2Date(31,12,2026);
                rSMGAPOsConditions.Insert();
            until rCondAPOs.Next() = 0;
    end;

    procedure FieldsUpdateItems()
    var
        rItem: Record Item;
        rHistValuesMargin: Record "SMG Historical Values Margin";
    begin
        // Se borra la tabla Histórical
        if rHistValuesMargin.FindSet() then
            rHistValuesMargin.DeleteAll();

        rItem.Reset();
        rItem.SetFilter("Item Category Code", '1*|2*|3*|4*|5*|6*|7*|8*');
        if rItem.FindSet() then
            repeat begin
                rItem."SMG RAEE Amount" := rItem."Importe RAEE";
                rItem."SMG Warranty %" := rItem."Garantia %";
                rItem."SMG Royalty %" := rItem."Royalty %";
                if rItem."Standard Cost" <> 0 then
                    rItem."SMG Standard Cost History" := true;
                if (rItem."Ecommerce Shipping Cost" <> 0) or
                    (rItem."Ecommerce Shipping Cost 2025" <> 0) then
                    ritem."SMG Trans Ecom Cost History" := true;
                rItem.Modify();

                // Standard Cost 2024
                if rItem."Standard Cost 2024" <> 0 then begin
                    Clear(rHistValuesMargin);
                    rHistValuesMargin.Init();
                    rHistValuesMargin."Item No." := rItem."No.";
                    rHistValuesMargin.Type := rHistValuesMargin.Type::"Standard Cost";
                    rHistValuesMargin."Starting Date" := DMY2Date(01, 01, 2024);
                    rHistValuesMargin."Ending Date" := DMY2Date(31, 12, 2024);
                    rHistValuesMargin."Cost Amount" := rItem."Standard Cost 2024";
                    rHistValuesMargin.Insert();
                end;

                // Standard Cost 2025
                if rItem."Standard Cost 2025" <> 0 then begin
                    Clear(rHistValuesMargin);
                    rHistValuesMargin.Init();
                    rHistValuesMargin."Item No." := rItem."No.";
                    rHistValuesMargin.Type := rHistValuesMargin.Type::"Standard Cost";
                    rHistValuesMargin."Starting Date" := DMY2Date(01, 01, 2025);
                    rHistValuesMargin."Ending Date" := DMY2Date(31, 12, 2025);
                    rHistValuesMargin."Cost Amount" := rItem."Standard Cost 2025";
                    rHistValuesMargin.Insert();
                end;

                // Standard Cost 2026
                if rItem."Standard Cost" <> 0 then begin
                    Clear(rHistValuesMargin);
                    rHistValuesMargin.Init();
                    rHistValuesMargin."Item No." := rItem."No.";
                    rHistValuesMargin.Type := rHistValuesMargin.Type::"Standard Cost";
                    rHistValuesMargin."Starting Date" := DMY2Date(01, 01, 2026);
                    //rHistValuesMargin."Ending Date" := DMY2Date(31, 12, 2026);
                    rHistValuesMargin."Cost Amount" := rItem."Standard Cost";
                    rHistValuesMargin.Insert();
                end;

                // Transport Ecommerce Cost 2025
                if rItem."Ecommerce Shipping Cost 2025" <> 0 then begin
                    Clear(rHistValuesMargin);
                    rHistValuesMargin.Init();
                    rHistValuesMargin."Item No." := rItem."No.";
                    rHistValuesMargin.Type := rHistValuesMargin.Type::"Ecomm Transport Cost";
                    rHistValuesMargin."Starting Date" := DMY2Date(01, 01, 2025);
                    rHistValuesMargin."Ending Date" := DMY2Date(31, 12, 2025);
                    rHistValuesMargin."Cost Amount" := rItem."Ecommerce Shipping Cost 2025";
                    rHistValuesMargin.Insert();
                end;

                // Transport Ecommerce Cost 2026
                if rItem."Ecommerce Shipping Cost" <> 0 then begin
                    Clear(rHistValuesMargin);
                    rHistValuesMargin.Init();
                    rHistValuesMargin."Item No." := rItem."No.";
                    rHistValuesMargin.Type := rHistValuesMargin.Type::"Ecomm Transport Cost";
                    rHistValuesMargin."Starting Date" := DMY2Date(01, 01, 2026);
                    //rHistValuesMargin."Ending Date" := DMY2Date(31, 12, 2026);
                    rHistValuesMargin."Cost Amount" := rItem."Ecommerce Shipping Cost";
                    rHistValuesMargin.Insert();
                end;

            end;
            until rItem.Next() = 0;
    end;

    procedure FieldsUpdateSalesHeader()
    var
        rSalesHeader: Record "Sales Header";
    begin
        rSalesHeader.Reset;
        if rSalesHeader.FindSet() then
            repeat begin
                rSalesHeader."SMG Blocked for Short Margin" := rSalesHeader."Blocked for Short Margin";
                rSalesHeader."SMG Total Margin %" := rSalesHeader."Margin %";

                rSalesHeader.Modify();
            end;
            until rSalesHeader.Next() = 0;
    end;

    procedure FieldsUpdateSalesLine()
    var
        rSalesLine: Record "Sales Line";
    begin
        rSalesLine.Reset;
        rSalesLine.SetRange(type, rSalesLine.Type::Item);
        if rSalesLine.FindSet() then
            repeat begin

                rSalesLine."SMG Discount 1 %" := rSalesLine."Discount 1 %";
                rSalesLine."SMG Discount 2 %" := rSalesLine."Discount 2 %";
                rSalesLine."SMG Discount 3 %" := rSalesLine."Discount 3 %";
                rSalesLine."SMG Discount 4 %" := rSalesLine."Discount 4 %";
                rSalesLine."SMG Discount 5 %" := rSalesLine."Discount 5 %";
                rSalesLine."SMG Discount 1 Amount" := rSalesLine."Discount 1 Amount";
                rSalesLine."SMG Discount 2 Amount" := rSalesLine."Discount 2 Amount";
                rSalesLine."SMG Discount 3 Amount" := rSalesLine."Discount 3 Amount";
                rSalesLine."SMG Discount 4 Amount" := rSalesLine."Discount 4 Amount";
                rSalesLine."SMG Discount 5 Amount" := rSalesLine."Discount 5 Amount";
                rSalesLine."SMG Discounts Total Amount" := rSalesLine."Discounts Total Amount";
                rSalesLine."SMG Commission %" := rSalesLine."Commission %";
                rSalesLine."SMG Commission Amount" := rSalesLine."Commission Amount";
                rSalesLine."SMG Net Unit Price" := rSalesLine."Net Unit Price";
                rSalesLine."SMG % APOS Excluded Invoice" := rSalesLine."Condiciones fuera fact. % APOS";
                rSalesLine."SMG % COLS Excluded Invoice" := rSalesLine."Condiciones fuera fact. % COLS";
                rSalesLine."SMG Transport Sales %" := rSalesLine."Transporte ventas %";
                rSalesLine."SMG Devs Fin %" := rSalesLine."DEVS  FIN %";
                rSalesLine."SMG Warranty %" := rSalesLine."Garantia %";
                rSalesLine."SMG Royalty %" := rSalesLine."Royalty %";
                rSalesLine."SMG RAEE Amount" := rSalesLine."Importe RAEE";
                rSalesLine."SMG Blocked for Short Margin" := rSalesLine."Blocked for Short Margin";
                rSalesLine."SMG Margin %" := rSalesLine."Margin %";
                rSalesLine."SMG Unit Margin Amount" := rSalesLine."Margin Amount";

                rSalesLine.Modify();
            end;
            until rSalesLine.Next() = 0;
    end;

    procedure FieldsUpdateSalesMargin()
    var
        rSalesHeader: Record "Sales Header";
        rSalesLine: Record "Sales Line";
        cuSMGManagement: Codeunit "SMG Management";
        vIniDateTime: DateTime;
        vFinDateTime: DateTime;
    begin
        //vInidatetime := CreateDateTime(20260401D, 000000T);
        vFinDateTime := CreateDateTime(20260401D, 000000T);
        rSalesHeader.Reset;
        rSalesHeader.SetRange("Document Type", rSalesHeader."Document Type"::Order);
        rSalesHeader.SetFilter(SystemCreatedAt, '<%1', vFinDateTime);
        if rSalesHeader.FindSet() then
            repeat begin
                rSalesLine.Reset();
                rSalesLine.SetRange("Document Type", rSalesHeader."Document Type");
                rSalesLine.SetRange("Document No.", rSalesHeader."No.");
                rSalesLine.SetRange(Type, rSalesLine.Type::Item);
                if rSalesLine.FindFirst() then begin
                    rSalesHeader."SMG Total Margin %" := cuSMGManagement.SMGCalculateTotalMargin(rSalesLine);
                    rSalesHeader.Modify();
                end;
            end;
            until rSalesHeader.Next() = 0;
    end;

    procedure FieldsUpdateSalesShipmentLine();
    var
        rSalesShipmentLine: Record "Sales Shipment Line";
    begin
        rSalesShipmentLine.Reset;
        rSalesShipmentLine.SetRange(type, rSalesShipmentLine.Type::Item);
        if rSalesShipmentLine.FindSet() then
            repeat begin

                rSalesShipmentLine."SMG Discount 1 %" := rSalesShipmentLine."Discount 1 %";
                rSalesShipmentLine."SMG Discount 2 %" := rSalesShipmentLine."Discount 2 %";
                rSalesShipmentLine."SMG Discount 3 %" := rSalesShipmentLine."Discount 3 %";
                rSalesShipmentLine."SMG Discount 4 %" := rSalesShipmentLine."Discount 4 %";
                rSalesShipmentLine."SMG Discount 5 %" := rSalesShipmentLine."Discount 5 %";
                rSalesShipmentLine."SMG Discount 1 Amount" := rSalesShipmentLine."Discount 1 Amount";
                rSalesShipmentLine."SMG Discount 2 Amount" := rSalesShipmentLine."Discount 2 Amount";
                rSalesShipmentLine."SMG Discount 3 Amount" := rSalesShipmentLine."Discount 3 Amount";
                rSalesShipmentLine."SMG Discount 4 Amount" := rSalesShipmentLine."Discount 4 Amount";
                rSalesShipmentLine."SMG Discount 5 Amount" := rSalesShipmentLine."Discount 5 Amount";
                rSalesShipmentLine."SMG Discounts Total Amount" := rSalesShipmentLine."Discounts Total Amount";
                rSalesShipmentLine."SMG Commission %" := rSalesShipmentLine."Commission %";
                rSalesShipmentLine."SMG Commission Amount" := rSalesShipmentLine."Commission Amount";
                rSalesShipmentLine."SMG Net Unit Price" := rSalesShipmentLine."Net Unit Price";

                rSalesShipmentLine.Modify();
            end;
            until rSalesShipmentLine.Next() = 0;
    end;

    procedure FieldsUpdateSalesInvoiceLine()
    var
        rSalesinvoiceLine: Record "Sales Invoice Line";
    begin
        rSalesinvoiceLine.Reset;
        rSalesinvoiceLine.SetRange(type, rSalesinvoiceLine.Type::Item);
        if rSalesinvoiceLine.FindSet() then
            repeat begin
                rSalesinvoiceLine."SMG Discount 1 %" := rSalesinvoiceLine."Discount 1 %";
                rSalesinvoiceLine."SMG Discount 2 %" := rSalesinvoiceLine."Discount 2 %";
                rSalesinvoiceLine."SMG Discount 3 %" := rSalesinvoiceLine."Discount 3 %";
                rSalesinvoiceLine."SMG Discount 4 %" := rSalesinvoiceLine."Discount 4 %";
                rSalesinvoiceLine."SMG Discount 5 %" := rSalesinvoiceLine."Discount 5 %";
                rSalesinvoiceLine."SMG Discount 1 Amount" := rSalesinvoiceLine."Discount 1 Amount";
                rSalesinvoiceLine."SMG Discount 2 Amount" := rSalesinvoiceLine."Discount 2 Amount";
                rSalesinvoiceLine."SMG Discount 3 Amount" := rSalesinvoiceLine."Discount 3 Amount";
                rSalesinvoiceLine."SMG Discount 4 Amount" := rSalesinvoiceLine."Discount 4 Amount";
                rSalesinvoiceLine."SMG Discount 5 Amount" := rSalesinvoiceLine."Discount 5 Amount";
                rSalesinvoiceLine."SMG Discounts Total Amount" := rSalesinvoiceLine."Discounts Total Amount";
                rSalesinvoiceLine."SMG Commission %" := rSalesinvoiceLine."Commission %";
                rSalesinvoiceLine."SMG Commission Amount" := rSalesinvoiceLine."Commission Amount";
                rSalesinvoiceLine."SMG Net Unit Price" := rSalesinvoiceLine."Net Unit Price";

                rSalesinvoiceLine.Modify();
            end;
            until rSalesinvoiceLine.Next() = 0;
    end;

    procedure FieldsUpdateSalesCreditMemoLine();
    var
        rSalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        rSalesCrMemoLine.Reset;
        rSalesCrMemoLine.SetRange(type, rSalesCrMemoLine.Type::Item);
        if rSalesCrMemoLine.FindSet() then
            repeat begin
                rSalesCrMemoLine."SMG Discount 1 %" := rSalesCrMemoLine."Discount 1 %";
                rSalesCrMemoLine."SMG Discount 2 %" := rSalesCrMemoLine."Discount 2 %";
                rSalesCrMemoLine."SMG Discount 3 %" := rSalesCrMemoLine."Discount 3 %";
                rSalesCrMemoLine."SMG Discount 4 %" := rSalesCrMemoLine."Discount 4 %";
                rSalesCrMemoLine."SMG Discount 5 %" := rSalesCrMemoLine."Discount 5 %";
                rSalesCrMemoLine."SMG Discount 1 Amount" := rSalesCrMemoLine."Discount 1 Amount";
                rSalesCrMemoLine."SMG Discount 2 Amount" := rSalesCrMemoLine."Discount 2 Amount";
                rSalesCrMemoLine."SMG Discount 3 Amount" := rSalesCrMemoLine."Discount 3 Amount";
                rSalesCrMemoLine."SMG Discount 4 Amount" := rSalesCrMemoLine."Discount 4 Amount";
                rSalesCrMemoLine."SMG Discount 5 Amount" := rSalesCrMemoLine."Discount 5 Amount";
                rSalesCrMemoLine."SMG Discounts Total Amount" := rSalesCrMemoLine."Discounts Total Amount";
                rSalesCrMemoLine."SMG Commission %" := rSalesCrMemoLine."Commission %";
                rSalesCrMemoLine."SMG Commission Amount" := rSalesCrMemoLine."Commission Amount";
                rSalesCrMemoLine."SMG Net Unit Price" := rSalesCrMemoLine."Net Unit Price";

                rSalesCrMemoLine.Modify();
            end;
            until rSalesCrMemoLine.Next() = 0;
    end;
}