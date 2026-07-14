Report 59001 "BBT Tool Item Liquid Repair"
{

    //Caption = 'Item Liquidation Repair', comment = 'ESP="Reparación Liquidación Producto"';
    Permissions = TableData "Item Ledger Entry" = M;
    ProcessingOnly = true;
    UseRequestPage = true;
    ApplicationArea = all;

    UsageCategory = ReportsAndAnalysis;

    dataset
    {

        dataitem(rItem; Item)
        {
            trigger OnAfterGetRecord()
            begin
                FindLocations();

                rLocation.Reset();
                if rLocation.FindSet() then
                    repeat begin

                        ItemQuantity := 0;
                        RemainingQuantity := 0;
                        rItemLedgerEntry.Reset;
                        rItemLedgerEntry.Setrange("Item No.", "No.");
                        rItemLedgerEntry.SetRange("Location Code", rLocation.Code);
                        if rItemLedgerEntry.FindSet then
                            repeat
                                ItemQuantity := ItemQuantity + rItemLedgerEntry.Quantity;
                                RemainingQuantity := RemainingQuantity + rItemLedgerEntry."Remaining Quantity";
                            until rItemLedgerEntry.Next = 0;

                        if ItemQuantity <> RemainingQuantity then begin
                            rItemLedgerEntry.Reset;
                            rItemLedgerEntry.Setrange("Item No.", "No.");
                            rItemLedgerEntry.SetRange("Location Code", rLocation.Code);
                            if rItemLedgerEntry.FindSet then
                                repeat
                                    ItemQuantity := rItemLedgerEntry.Quantity;
                                    RemainingQuantity := rItemLedgerEntry."Remaining Quantity";
                                    BalanceQuantity := 0;
                                    rItemApplicationEntry.Reset();
                                    rItemApplicationEntry.SetRange("Inbound Item Entry No.", rItemLedgerEntry."Entry No.");
                                    rItemApplicationEntry.SetRange("Location Code", rLocation.Code);
                                    if rItemApplicationEntry.FindSet then
                                        repeat
                                            BalanceQuantity := BalanceQuantity + rItemApplicationEntry.Quantity;
                                        until rItemApplicationEntry.Next = 0;

                                    if RemainingQuantity <> BalanceQuantity then begin
                                        Message('Producto %1 Movimiento %2  Diferencia en liquidación:  Cantidad %3 - Pendiente %4 - Balance %5',
                                                rItem."No.", rItemLedgerEntry."Entry No.", ItemQuantity, RemainingQuantity, BalanceQuantity);
                                        if UpdateBalance and (BalanceQuantity >= 0) then begin
                                            if BalanceQuantity > 0 then begin
                                                rItemLedgerEntry."Remaining Quantity" := BalanceQuantity;
                                                rItemLedgerEntry.Open := true;
                                            end
                                            else begin  //BalanceQuantity = 0
                                                rItemLedgerEntry."Remaining Quantity" := BalanceQuantity;
                                                rItemLedgerEntry.Open := false;
                                            end;
                                            rItemLedgerEntry.Modify(true);
                                            Commit();
                                        end;
                                    end;
                                until rItemLedgerEntry.Next = 0;
                        end;
                    end;
                    until rLocation.Next() = 0;
            end;
        }
    }

    requestpage
    {

        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', comment = 'ESP="Opciones"';

                    field(ItemNo; ItemNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item', comment = 'ESP="Producto"';
                    }
                    field(UpdateBalance; UpdateBalance)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Update Balance', comment = 'ESP="Modifica Liquidación"';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            rItem.SetFilter("Item Category Code", '%1..%2', '1', '899999');
            rItem.SetRange("No.", ItemNo);
            UpdateBalance := false;
        end;
    }
    labels
    {
    }
    trigger OnPreReport()
    begin
    end;

    var
        rItemLedgerEntry: Record "Item Ledger Entry";
        rItemApplicationEntry: Record "Item Application Entry";
        ItemQuantity: decimal;
        RemainingQuantity: Decimal;
        BalanceQuantity: Decimal;
        UpdateBalance: Boolean;
        ItemNo: Code[20];
        rLocation: Record Location temporary;


    local procedure FindLocations()
    begin
        rItemLedgerEntry.Reset;
        rItemLedgerEntry.Setrange("Item No.", ItemNo);
        if rItemLedgerEntry.FindSet then
            repeat
                rLocation.Reset();
                rLocation.SetRange(Code, rItemLedgerEntry."Location Code");
                if not rLocation.FindFirst() then begin
                    rLocation.Init();
                    rLocation.Code := rItemLedgerEntry."Location Code";
                    rLocation.Insert()
                end;
            until rItemLedgerEntry.Next() = 0;
    end;
}
