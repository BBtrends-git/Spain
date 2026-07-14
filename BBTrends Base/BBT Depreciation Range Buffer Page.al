page 50117 "BBT Depreciation Range Buffer"
{
    ApplicationArea = All;
    Caption = 'Item Depreciation Buffer', Comment = 'ESP="Diario depreciación producto"';
    PageType = Worksheet;
    SaveValues = true;
    UsageCategory = Tasks;
    SourceTable = "BBT Depreciation Buffer";

    layout
    {
        area(Content)
        {
            group(Control1)
            {
                Caption = 'Options', Comment = 'ESP="Opciones"';

                field(DepreciationDate; vDepreciationDate)
                {
                    ApplicationArea = All;
                    Caption = 'Depreciation Date', Comment = 'ESP="Fecha depreciación"';
                }
                field(JournalTemplateName; vJournalTemplateName)
                {
                    ApplicationArea = All;
                    Caption = 'Journal Template Name', Comment = 'ESP="Nombre diario"';
                    TableRelation = "Gen. Journal Template";
                }
                field(JournalBatchName; vJournalBatchName)
                {
                    ApplicationArea = All;
                    Caption = 'Journal Batch Name', Comment = 'ESP="Nombre sección diario"';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rlGenJournalBatch: Record "Gen. Journal Batch";
                        glGenJournalBatch: Page "General Journal Batches";
                    begin
                        rlGenJournalBatch.Reset();
                        Clear(glGenJournalBatch);
                        rlGenJournalBatch.SetRange("Journal Template Name", vJournalTemplateName);
                        glGenJournalBatch.SetTableView(rlGenJournalBatch);
                        if glGenJournalBatch.RunModal() in [Action::OK, Action::LookupOK] then begin
                            vJournalBatchName := glGenJournalBatch.GetSelectionFilter();
                        end;
                    end;
                }
            }
            repeater(Control2)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Standard Cost"; Rec."Standard Cost")
                {
                    ApplicationArea = All;
                }
                field("Inventory Value Amount"; Rec."Inventory Value Amount")
                {
                    ApplicationArea = All;
                }
                field("% Depreciation"; Rec."% Depreciation")
                {
                    ApplicationArea = All;
                }
                field("Depreciated Amount"; Rec."Depreciated Amount")
                {
                    ApplicationArea = All;
                    StyleExpr = 'Strong';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action("Fill Depreciation Table")
            {
                Caption = 'Fill Depreciation Table', Comment = 'ESP="Rellenar tabla depreciación"';
                Image = SuggestTables;
                ApplicationArea = All;

                trigger OnAction()
                var
                    rlItem: Record Item;
                    rlItemLedgerEntry: Record "Item Ledger Entry";
                    rlDepreciationRange: Record "BBT Depreciation Range";
                    rlDepreciationRange2: Record "BBT Depreciation Range";
                    Text001Err: Label 'You must insert the depreciation date.', Comment = 'ESP="Debe introducir una fecha depreciación."';
                    vDays: Integer;
                begin
                    if vDepreciationDate = 0D then Error(Text001Err);
                    Rec.Reset();
                    if Rec.FindSet() then Rec.DeleteAll();
                    rlItem.Reset();
                    rlItem.SetFilter("Item Category Code", '%1..%2', '10', '8999');
                    rlItem.SetFilter(Inventory, '>%1', 0);
                    if rlItem.FindSet() then
                        repeat
                            rlItem.CalcFields(Inventory);
                            if rlItem.Inventory > 0 then begin
                                rlItemLedgerEntry.Reset();
                                rlItemLedgerEntry.SetCurrentKey("Item No.", "Posting Date");
                                rlItemLedgerEntry.SetRange("Item No.", rlItem."No.");
                                rlItemLedgerEntry.SetFilter("Entry Type", '%1|%2', rlItemLedgerEntry."Entry Type"::Purchase, rlItemLedgerEntry."Entry Type"::Sale);
                                rlItemLedgerEntry.SetAscending("Posting Date", true);
                                if rlItemLedgerEntry.FindLast() then begin
                                    Clear(vDays);
                                    vDays := vDepreciationDate - rlItemLedgerEntry."Posting Date";
                                    rlDepreciationRange.Reset();
                                    rlDepreciationRange.SetFilter("Depreciation Days", '>=%1', vDays);
                                    if rlDepreciationRange.FindFirst() then
                                        if rlDepreciationRange."% Depreciation" <> 0 then begin
                                            Rec.Init();
                                            Rec."Item No." := rlItemLedgerEntry."Item No.";
                                            Rec.Insert();
                                            Rec.Quantity := rlItem.Inventory;
                                            if rlItem."Costing Method" = rlItem."Costing Method"::Standard then
                                                Rec."Standard Cost" := rlItem."Standard Cost"
                                            else
                                                Rec."Standard Cost" := rlItem."Unit Cost";
                                            Rec."% Depreciation" := rlDepreciationRange."% Depreciation";
                                            Rec."Inventory Value Amount" := Round(rlItem.Inventory * Rec."Standard Cost", 0.01);
                                            Rec."Depreciated Amount" := Round(rlItem.Inventory * Rec."Standard Cost" * rlDepreciationRange."% Depreciation" / 100, 0.01);
                                            Rec."Item Category Code" := rlItem."Item Category Code";
                                            Rec.Modify();
                                        end;
                                end
                                else begin
                                    rlDepreciationRange2.Reset();
                                    if rlDepreciationRange2.FindLast() then;
                                    Rec.Init();
                                    Rec."Item No." := rlItem."No.";
                                    Rec.Insert();
                                    Rec.Quantity := rlItem.Inventory;
                                    if rlItem."Costing Method" = rlItem."Costing Method"::Standard then
                                        Rec."Standard Cost" := rlItem."Standard Cost"
                                    else
                                        Rec."Standard Cost" := rlItem."Unit Cost";
                                    Rec."% Depreciation" := rlDepreciationRange2."% Depreciation";
                                    Rec."Inventory Value Amount" := Round(rlItem.Inventory * Rec."Standard Cost", 0.01);
                                    Rec."Depreciated Amount" := Round(rlItem.Inventory * Rec."Standard Cost" * rlDepreciationRange2."% Depreciation" / 100, 0.01);
                                    Rec."Item Category Code" := rlItem."Item Category Code";
                                    Rec.Modify();
                                end;
                            end;
                        until rlItem.Next() = 0;
                end;
            }
            action("Create Depreciation Journal")
            {
                Caption = 'Create Depreciation Journal', Comment = 'ESP="Generar diario depreciación"';
                Image = PostedVendorBill;
                ApplicationArea = All;

                trigger OnAction()
                var
                    vDocumentNo: Text;
                    vYear: Integer;
                    vDescription: Text;
                    NoSeries: Codeunit "No. Series";
                    rlInventorySetup: Record "Inventory Setup";
                    rlGenJournalLine: Record "Gen. Journal Line";
                    Text002Err: Label 'You must insert the journal name.', Comment = 'ESP="Debe introducir un diario."';
                    Text003Err: Label 'You must insert the journal batch name.', Comment = 'ESP="Debe introducir una sección del diario."';
                    Text001Msg: Label 'Process completed. Do you want to open the journal?', Comment = 'ESP="Las líneas se han generado con éxito. ¿Desea abrir el diario?"';
                    Text002Msg: Label 'There is not information to insert in the journal.', Comment = 'ESP="No hay nada que enviar al diario."';
                begin
                    if vJournalTemplateName = '' then Error(Text002Err);
                    if vJournalBatchName = '' then Error(Text003Err);
                    rlGenJournalLine.Reset();
                    rlGenJournalLine.SetRange("Journal Template Name", vJournalTemplateName);
                    rlGenJournalLine.SetRange("Journal Batch Name", vJournalBatchName);
                    if rlGenJournalLine.FindSet() then rlGenJournalLine.DeleteAll();
                    if Rec.FindSet() then begin
                        rlInventorySetup.Get();
                        Clear(vYear);
                        vYear := Date2DMY(vDepreciationDate, 3);
                        Clear(vDocumentNo);
                        vDocumentNo := NoSeries.GetNextNo(rlInventorySetup."Depreciation Nos.", 0D, true);
                        repeat
                            if Rec."Depreciated Amount" <> 0 then begin
                                Clear(rlGenJournalLine);
                                rlGenJournalLine.Init();
                                rlGenJournalLine.Validate("Journal Template Name", vJournalTemplateName);
                                rlGenJournalLine.Validate("Journal Batch Name", vJournalBatchName);
                                rlGenJournalLine.Validate("Line No.", fGetNextLineNo());
                                rlGenJournalLine.Insert(true);
                                rlGenJournalLine.Validate("Document No.", vDocumentNo);
                                rlGenJournalLine.Validate("Account Type", rlGenJournalLine."Account Type"::"G/L Account");
                                rlGenJournalLine.Validate("Account No.", rlInventorySetup."Item Depreciation No.");
                                rlGenJournalLine.Validate("Posting Date", vDepreciationDate);
                                Clear(vDescription);
                                vDescription := 'DEPRECIACION ' + Format(vYear) + ' - ' + Format(Rec."% Depreciation") + '% - ' + Format(Rec."Item No.");
                                rlGenJournalLine.Validate(Description, vDescription);
                                rlGenJournalLine.Validate("Credit Amount", Round(Rec."Depreciated Amount", 0.01));
                                rlGenJournalLine."Gen. Posting Type" := rlGenJournalLine."Gen. Posting Type"::" ";
                                rlGenJournalLine."Bal. Gen. Posting Type" := rlGenJournalLine."Bal. Gen. Posting Type"::" ";
                                rlGenJournalLine."Gen. Bus. Posting Group" := '';
                                rlGenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                                rlGenJournalLine."Gen. Prod. Posting Group" := '';
                                rlGenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                                rlGenJournalLine."VAT Bus. Posting Group" := '';
                                rlGenJournalLine."Bal. VAT Bus. Posting Group" := '';
                                rlGenJournalLine."VAT Prod. Posting Group" := '';
                                rlGenJournalLine."Bal. VAT Prod. Posting Group" := '';
                                rlGenJournalLine.Modify(true);
                            end;
                        until Rec.Next() = 0;
                        Clear(rlGenJournalLine);
                        rlGenJournalLine.Init();
                        rlGenJournalLine.Validate("Journal Template Name", vJournalTemplateName);
                        rlGenJournalLine.Validate("Journal Batch Name", vJournalBatchName);
                        rlGenJournalLine.Validate("Line No.", fGetNextLineNo());
                        rlGenJournalLine.Insert(true);
                        rlGenJournalLine.Validate("Document No.", vDocumentNo);
                        rlGenJournalLine.Validate("Account Type", rlGenJournalLine."Account Type"::"G/L Account");
                        rlGenJournalLine.Validate("Account No.", rlInventorySetup."Inventory Depreciation No.");
                        rlGenJournalLine.Validate("Posting Date", vDepreciationDate);
                        Clear(vDescription);
                        vDescription := 'DEPRECIACION ' + Format(vYear);
                        rlGenJournalLine.Validate(Description, vDescription);
                        Rec.CalcSums("Depreciated Amount");
                        rlGenJournalLine.Validate("Debit Amount", Round(Rec."Depreciated Amount", 0.01));
                        rlGenJournalLine."Gen. Posting Type" := rlGenJournalLine."Gen. Posting Type"::" ";
                        rlGenJournalLine."Bal. Gen. Posting Type" := rlGenJournalLine."Bal. Gen. Posting Type"::" ";
                        rlGenJournalLine."Gen. Bus. Posting Group" := '';
                        rlGenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                        rlGenJournalLine."Gen. Prod. Posting Group" := '';
                        rlGenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                        rlGenJournalLine."VAT Bus. Posting Group" := '';
                        rlGenJournalLine."Bal. VAT Bus. Posting Group" := '';
                        rlGenJournalLine."VAT Prod. Posting Group" := '';
                        rlGenJournalLine."Bal. VAT Prod. Posting Group" := '';
                        rlGenJournalLine.Modify(true);
                        if Confirm(Text001Msg) then begin
                            rGeneralJournalLine.SetRange("Journal Template Name", vJournalTemplateName);
                            rGeneralJournalLine.SetRange("Journal Batch Name", vJournalBatchName);
                            if rGeneralJournalLine.FindFirst() then begin
                                gGeneralJournal.SetRecord(rGeneralJournalLine);
                                gGeneralJournal.SetTableView(rGeneralJournalLine);
                                gGeneralJournal.Run();
                            end;
                        end
                        else
                            Message(Text002Msg);
                    end;
                end;
            }
        }
    }
    procedure fGetNextLineNo(): Decimal
    var
        rlGenJournalLine: Record "Gen. Journal Line";
    begin
        rlGenJournalLine.Reset();
        rlGenJournalLine.SetRange("Journal Template Name", vJournalTemplateName);
        rlGenJournalLine.SetRange("Journal Batch Name", vJournalBatchName);
        if rlGenJournalLine.FindLast() then
            exit(rlGenJournalLine."Line No." + 10000)
        else
            exit(10000);
    end;

    var
        vJournalTemplateName: Code[10];
        vJournalBatchName: Code[10];
        vDepreciationDate: Date;
        rGeneralJournalLine: Record "Gen. Journal Line";
        gGeneralJournal: Page "General Journal";
}
