report 50019 "BBT Residues Declaration"
{
    Caption = 'BBT Residues Declaration', Comment = 'ESP="BBT Declaración residuos"';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Filters', Comment = 'ESP="Filtros"';
                    field(StartingDate; StartingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date', Comment = 'ESP="Fecha inicio"';
                        ShowMandatory = true;
                        ToolTip = 'Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.';
                        trigger OnValidate()
                        var
                            Text001Err: Label 'Starting date must not be superior than Ending date.', Comment = 'ESP="La fecha inicio no puede ser superior a la fecha fin."';
                        begin
                            if EndingDate <> 0D then
                                if StartingDate > EndingDate then
                                    Error(Text001Err);
                        end;
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date', Comment = 'ESP="Fecha fin"';
                        ShowMandatory = true;
                        ToolTip = 'Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.';
                        trigger OnValidate()
                        var
                            Text001Err: Label 'Ending date must be superior than Starting date.', Comment = 'ESP="La fecha fin no puede ser inferior a la fecha inicio."';
                        begin
                            if StartingDate <> 0D then
                                if EndingDate < StartingDate then
                                    Error(Text001Err);
                        end;
                    }
                    field(CustomerNo; CustomerNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer No.', Comment = 'ESP="Nº cliente"';
                        ToolTip = 'Specifies the customer.';
                        TableRelation = Customer;
                    }
                    field(CustomerCountry; CustomerCountry)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Country/Region Code', Comment = 'ESP="Cód. país"';
                        ToolTip = 'Specifies the country.';
                        TableRelation = "Country/Region";
                    }
                    field(ItemCategory; ItemCategory)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Category', Comment = 'ESP="Categoría producto"';
                        ToolTip = 'Specifies the Item category.';
                        TableRelation = "Item Category";
                    }
                }
            }
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        rlItem: Record Item;
        rlItemCategory: Record "Item Category";
        rlItemLedgerEntry: Record "Item Ledger Entry";
        rlItemLedgerEntry2: Record "Item Ledger Entry";
        rlxItemLedgerEntry: Record "Item Ledger Entry";
        rlTempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        rlShippingAgent: Record "Shipping Agent";
        Text001Msg: Label 'There is not any document to process.', Comment = 'ESP="No se ha encontrado ningún documento a procesar."';
        Text001Err: Label 'You must introduce the starting date and the ending date.', Comment = 'ESP="Debe introducir tanto la fecha inicio como la fecha fin."';
    begin
        if (StartingDate = 0D) or (EndingDate = 0D) then
            Error(Text001Err);
        rlTempItemLedgerEntry.Reset();
        if rlTempItemLedgerEntry.FindSet() then
            rlTempItemLedgerEntry.DeleteAll();
        rlItem.Reset();
        if ItemCategory <> '' then
            rlItem.SetRange("Item Category Code", ItemCategory);
        rlItem.SetAscending("No.", true);
        if rlItem.FindSet() then
            repeat
                if rlItemCategory.Get(rlItem."Item Category Code") then
                    if rlItemCategory."Residues Declaration" then begin
                        rlItemLedgerEntry.Reset();
                        rlItemLedgerEntry.SetRange("Entry Type", rlItemLedgerEntry."Entry Type"::Sale);
                        rlItemLedgerEntry.SetFilter("Document Type", '%1|%2|%3|%4', rlItemLedgerEntry."Document Type"::"Sales Invoice", rlItemLedgerEntry."Document Type"::"Sales Credit Memo", rlItemLedgerEntry."Document Type"::"Sales Return Receipt", rlItemLedgerEntry."Document Type"::"Sales Shipment");
                        rlItemLedgerEntry.SetRange("Posting Date", StartingDate, EndingDate);
                        if CustomerNo <> '' then
                            rlItemLedgerEntry.SetRange("Source No.", CustomerNo);

                        if CustomerCountry <> '' then
                            //rlItemLedgerEntry.SetRange("Country/Region Code", CustomerCountry);
                            rlItemLedgerEntry.SetFilter("Country/Region Code", '%1', CustomerCountry);
                        if CustomerCountry = 'ES' then
                            rlItemLedgerEntry.SetFilter("Country/Region Code", '%1|%2', 'ES', '');

                        rlItemLedgerEntry.SetRange("Item No.", rlItem."No.");
                        rlItemLedgerEntry.SetAscending("Entry No.", true);
                        if rlItemLedgerEntry.FindSet() then
                            repeat
                                if rlxItemLedgerEntry."Item No." <> rlItemLedgerEntry."Item No." then begin
                                    rlTempItemLedgerEntry.Init();
                                    rlTempItemLedgerEntry."Entry No." := rlItemLedgerEntry."Entry No.";
                                    rlTempItemLedgerEntry."Item No." := rlItemLedgerEntry."Item No.";
                                    rlTempItemLedgerEntry.Description := rlItem.Description;
                                    rlTempItemLedgerEntry."Remaining Quantity" := 0;
                                    rlTempItemLedgerEntry."Reserved Quantity" := 0;
                                    rlTempItemLedgerEntry."Invoiced Quantity" := 0;
                                    rlTempItemLedgerEntry.Insert();
                                end;
                                if rlItemLedgerEntry."Document Type" in [rlItemLedgerEntry."Document Type"::"Sales Invoice", rlItemLedgerEntry."Document Type"::"Sales Shipment"] then begin

                                    if rlItemLedgerEntry."Country/Region Code" in ['ES', ''] then
                                        rlTempItemLedgerEntry."Remaining Quantity" += -rlItemLedgerEntry.Quantity
                                    else
                                        rlTempItemLedgerEntry."Reserved Quantity" += -rlItemLedgerEntry.Quantity;
                                end else begin

                                    if rlItemLedgerEntry."Country/Region Code" in ['ES', ''] then
                                        rlTempItemLedgerEntry."Remaining Quantity" -= rlItemLedgerEntry.Quantity
                                    else
                                        rlTempItemLedgerEntry."Reserved Quantity" -= rlItemLedgerEntry.Quantity;
                                end;
                                rlTempItemLedgerEntry."Invoiced Quantity" += -rlItemLedgerEntry.Quantity;
                                rlTempItemLedgerEntry.Modify(false);
                                /*                               
                                    if rlxItemLedgerEntry."Item No." = rlItemLedgerEntry."Item No." then begin
                                        rlTempItemLedgerEntry."Item No." := rlItemLedgerEntry."Item No.";
                                        rlTempItemLedgerEntry.Description := rlItem.Description;
                                        if rlItemLedgerEntry."Document Type" in [rlItemLedgerEntry."Document Type"::"Sales Invoice", rlItemLedgerEntry."Document Type"::"Sales Shipment"] then begin
                                            //>> PARA REVISAR en la extensió ITK 
                                            if rlItemLedgerEntry."Country/Region Code" in ['ES', ''] then
                                                //<<
                                                rlTempItemLedgerEntry."Remaining Quantity" += -rlItemLedgerEntry.Quantity
                                            else
                                                rlTempItemLedgerEntry."Reserved Quantity" += -rlItemLedgerEntry.Quantity;
                                        end else begin
                                            //>> PARA REVISAR en la extensió ITK 
                                            if rlItemLedgerEntry."Country/Region Code" in ['ES', ''] then
                                                //<<
                                                rlTempItemLedgerEntry."Remaining Quantity" -= rlItemLedgerEntry.Quantity
                                            else
                                                rlTempItemLedgerEntry."Reserved Quantity" -= rlItemLedgerEntry.Quantity;
                                        end;
                                        rlTempItemLedgerEntry."Invoiced Quantity" += -rlItemLedgerEntry.Quantity;
                                        rlTempItemLedgerEntry.Modify(false);

                                    end else begin
                                        rlTempItemLedgerEntry.Init();
                                        rlTempItemLedgerEntry."Entry No." := rlItemLedgerEntry."Entry No.";
                                        rlTempItemLedgerEntry."Item No." := rlItemLedgerEntry."Item No.";
                                        rlTempItemLedgerEntry.Description := rlItem.Description;
                                        rlTempItemLedgerEntry."Remaining Quantity" := 0;
                                        rlTempItemLedgerEntry."Reserved Quantity" := 0;
                                        rlTempItemLedgerEntry."Invoiced Quantity" := 0;
                                        if rlItemLedgerEntry."Document Type" in [rlItemLedgerEntry."Document Type"::"Sales Invoice", rlItemLedgerEntry."Document Type"::"Sales Shipment"] then begin
                                            //>> PARA REVISAR en la extensió ITK 
                                            if rlItemLedgerEntry."Country/Region Code" in ['ES', ''] then
                                                //<<
                                                rlTempItemLedgerEntry."Remaining Quantity" += -rlItemLedgerEntry.Quantity
                                            else
                                                rlTempItemLedgerEntry."Reserved Quantity" += -rlItemLedgerEntry.Quantity;
                                        end else begin
                                            //>> PARA REVISAR en la extensió ITK 
                                            if rlItemLedgerEntry."Country/Region Code" in ['ES', ''] then
                                                //<<
                                                rlTempItemLedgerEntry."Remaining Quantity" -= rlItemLedgerEntry.Quantity
                                            else
                                                rlTempItemLedgerEntry."Reserved Quantity" -= rlItemLedgerEntry.Quantity;
                                        end;
                                        rlTempItemLedgerEntry."Invoiced Quantity" += -rlItemLedgerEntry.Quantity;
                                        rlTempItemLedgerEntry.Insert(false);
                                    end;
                                */
                                rlxItemLedgerEntry := rlItemLedgerEntry;

                            until rlItemLedgerEntry.Next() = 0;
                    end;
            until rlItem.Next() = 0;
        fExportInventoryToExcel(rlTempItemLedgerEntry);
    end;

    var
        StartingDate: Date;
        EndingDate: Date;
        CustomerNo: Code[20];
        CustomerCountry: Code[20];
        ItemCategory: Code[20];
        QtyUnitMeasure: Decimal;

    local procedure fExportInventoryToExcel(var pItemLedgerEntry: Record "Item Ledger Entry" temporary)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        rlResidues: Record "BBT Residues";
        rlItemResidues: Record "BBT Item Residues";
        rItemUnitMeasure: Record "Item Unit of Measure";
        ASMLbl: Label 'Residuos_%1';
        TemporalPickupDocumentsLbl: Label 'Residues Calculation', Comment = 'ESP="Cálculo residuos"';
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(pItemLedgerEntry.FieldCaption("Item No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(pItemLedgerEntry.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //     TempExcelBuffer.AddColumn(pItemLedgerEntry.FieldCaption("Country/Region Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Cantidad ES', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Cantidad NO NAC', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        rlResidues.Reset();
        rlResidues.SetCurrentKey(Order);
        rlResidues.SetRange("Show in Declaration", true);
        rlResidues.SetAscending(Order, true);
        if rlResidues.FindSet() then
            repeat
                TempExcelBuffer.AddColumn(rlResidues."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until rlResidues.Next() = 0;
        //>> PARA REVISAR en la extensión ITK
        //pItemLedgerEntry.SetFilter("Remaining Quantity", '<>%1', 0);      ¿¿¿ SI o NO ???
        //<< 
        if pItemLedgerEntry.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(pItemLedgerEntry."Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(pItemLedgerEntry.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                //  TempExcelBuffer.AddColumn(pItemLedgerEntry."Country/Region Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(pItemLedgerEntry."Remaining Quantity", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(pItemLedgerEntry."Reserved Quantity", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                rlResidues.Reset();
                rlResidues.SetCurrentKey(Order);
                rlResidues.SetRange("Show in Declaration", true);
                rlResidues.SetAscending(Order, true);
                if rlResidues.FindSet() then
                    repeat
                        rlItemResidues.Reset();
                        rlItemResidues.SetRange("Item No.", pItemLedgerEntry."Item No.");
                        rlItemResidues.SetRange("Residue No.", rlResidues."No.");
                        if rlItemResidues.FindFirst() then begin
                            if rlItemResidues."Numeric Value" <> 0 then begin
                                if rlItemResidues."Residue No." = 'CAJMSTVAC' then begin // Residuo Caja Master
                                    QtyUnitMeasure := 1;
                                    rItemUnitMeasure.Reset();
                                    rItemUnitMeasure.SetRange("Item No.", pItemLedgerEntry."Item No.");
                                    rItemUnitMeasure.SetRange(Code, 'CAJA');
                                    if rItemUnitMeasure.FindFirst() then
                                        QtyUnitMeasure := rItemUnitMeasure."Qty. per Unit of Measure";
                                    TempExcelBuffer.AddColumn((Round((rlItemResidues."Numeric Value" / QtyUnitMeasure) *
                                                                    (pItemLedgerEntry."Remaining Quantity" + pItemLedgerEntry."Reserved Quantity"), 0.01)),
                                                                    false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                                end
                                else begin
                                    TempExcelBuffer.AddColumn((Round(rlItemResidues."Numeric Value" *
                                                                    (pItemLedgerEntry."Remaining Quantity" + pItemLedgerEntry."Reserved Quantity"), 0.01)),
                                                                    false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                                end
                            end
                            else begin
                                TempExcelBuffer.AddColumn(rlItemResidues."Option Value", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            end;
                        end
                        else begin
                            TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        end;
                    until rlResidues.Next() = 0;
            until pItemLedgerEntry.Next() = 0;
        TempExcelBuffer.CreateNewBook(TemporalPickupDocumentsLbl);
        TempExcelBuffer.WriteSheet(TemporalPickupDocumentsLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ASMLbl, CurrentDateTime));
        TempExcelBuffer.OpenExcel();
    end;
}