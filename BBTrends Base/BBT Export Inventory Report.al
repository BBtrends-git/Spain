report 50018 "BBT Export Inventory"
{
    Caption = 'Export Inventory', Comment = 'ESP="Exportar inventario"';
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
                    Caption = 'Options', Comment = 'ESP="Filtros"';

                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
                        ToolTip = 'Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.';
                    }
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Location Code', Comment = 'ESP="Cód. almacén"';
                        ToolTip = 'Specifies the location code.';
                        TableRelation = Location;
                    }
                    field(ItemNo; ItemNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item No.', Comment = 'ESP="Nº producto"';
                        ToolTip = 'Specifies the item.';
                        TableRelation = Item;
                    }
                }
            }
        }
    }
    trigger OnPostReport()
    var
        rlItem: Record Item;
        rlItemLedgerEntry: Record "Item Ledger Entry";
        rlxItemLedgerEntry: Record "Item Ledger Entry";
        rlTempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        rlShippingAgent: Record "Shipping Agent";
        Text001Msg: Label 'There is not any document to process.', Comment = 'ESP="No se ha encontrado ningún documento a procesar."';
    begin
        if PostingDate = 0D then PostingDate := WorkDate();
        rlTempItemLedgerEntry.Reset();
        if rlTempItemLedgerEntry.FindSet() then rlTempItemLedgerEntry.DeleteAll();
        rlItem.Reset();
        if ItemNo <> '' then rlItem.SetRange("No.", ItemNo);
        if rlItem.FindSet() then
            repeat
                rlItemLedgerEntry.Reset();
                rlItemLedgerEntry.SetFilter("Posting Date", '<=%1', PostingDate);
                if LocationCode <> '' then rlItemLedgerEntry.SetRange("Location Code", LocationCode);
                rlItemLedgerEntry.SetRange("Item No.", rlItem."No.");
                rlItemLedgerEntry.SetCurrentKey("Location Code");
                if rlItemLedgerEntry.FindSet() then
                    repeat
                        if rlxItemLedgerEntry."Item No." = rlItemLedgerEntry."Item No." then begin
                            if rlxItemLedgerEntry."Location Code" <> rlItemLedgerEntry."Location Code" then begin
                                rlTempItemLedgerEntry.Init();
                                rlTempItemLedgerEntry := rlItemLedgerEntry;
                                rlTempItemLedgerEntry.Description := rlItem.Description;
                                rlTempItemLedgerEntry."Remaining Quantity" := rlItemLedgerEntry.Quantity;
                                if PostingDate <> 0D then rlTempItemLedgerEntry."Posting Date" := PostingDate;
                                rlTempItemLedgerEntry.Insert(false);
                            end
                            else begin
                                rlTempItemLedgerEntry."Remaining Quantity" += rlItemLedgerEntry."Quantity";
                                rlTempItemLedgerEntry.Modify(false);
                            end;
                        end
                        else begin
                            rlTempItemLedgerEntry.Init();
                            rlTempItemLedgerEntry := rlItemLedgerEntry;
                            rlTempItemLedgerEntry.Description := rlItem.Description;
                            rlTempItemLedgerEntry."Remaining Quantity" := rlItemLedgerEntry.Quantity;
                            if PostingDate <> 0D then rlTempItemLedgerEntry."Posting Date" := PostingDate;
                            rlTempItemLedgerEntry.Insert(false);
                        end;
                        rlxItemLedgerEntry := rlItemLedgerEntry;
                    until rlItemLedgerEntry.Next() = 0;
            until rlItem.Next() = 0;
        fExportInventoryToExcel(rlTempItemLedgerEntry);
    end;

    var
        PostingDate: Date;
        LocationCode: Code[20];
        ItemNo: Code[20];

    local procedure fExportInventoryToExcel(var pItemLedgerEntry: Record "Item Ledger Entry" temporary)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ASMLbl: Label 'Inventario_%1';
        TemporalPickupDocumentsLbl: Label 'Inventory', Comment = 'ESP="Inventario_Físico"';
        rlItem: Record Item;
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(pItemLedgerEntry.FieldCaption("Posting Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(pItemLedgerEntry.FieldCaption("Item No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(pItemLedgerEntry.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(pItemLedgerEntry.FieldCaption("Location Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(pItemLedgerEntry.FieldCaption(Quantity), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(rlItem.FieldCaption("Standard Cost"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(rlItem.FieldCaption("Unit Cost"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        pItemLedgerEntry.SetFilter("Remaining Quantity", '<>%1', 0);
        pItemLedgerEntry.SetFilter("Remaining Quantity", '<>%1', 0);
        if pItemLedgerEntry.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(pItemLedgerEntry."Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(pItemLedgerEntry."Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(pItemLedgerEntry.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(pItemLedgerEntry."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(pItemLedgerEntry."Remaining Quantity", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                if rlItem.Get(pItemLedgerEntry."Item No.") then begin
                    TempExcelBuffer.AddColumn(rlItem."Standard Cost", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(rlItem."Unit Cost", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                end;
            until pItemLedgerEntry.Next() = 0;
        TempExcelBuffer.CreateNewBook(TemporalPickupDocumentsLbl);
        TempExcelBuffer.WriteSheet(TemporalPickupDocumentsLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ASMLbl, CurrentDateTime));
        TempExcelBuffer.OpenExcel();
    end;
}
