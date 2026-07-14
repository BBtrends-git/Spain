PageExtension 50113 "BBT Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Variant Code")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Qty. per Unit of Measure")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = Basic;
            }
            field("Hora Registro"; Rec."Hora Registro")
            {
                ApplicationArea = Basic;
            }
            field("Work Shift Code"; Rec."Work Shift Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Job Task No.")
        {
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Source No.")
        {
            field(SourceName; SourceName)
            {
                ApplicationArea = Basic;
                Caption = 'Desc. Origin Mov.', Comment = 'ESP="Desc. Procedencia Mov."';
            }
        }
    }
    var
        SourceName: Text;
        rCustomer: Record Customer;
        rVendor: Record Vendor;
        rItem: Record Item;

    trigger OnAfterGetRecord()
    begin
        SourceName := '';
        if Rec."Source Type" = Rec."Source Type"::Customer then begin
            ;
            if rCustomer.GET(Rec."Source No.") then
                SourceName := rCustomer.Name;
        end;
        if Rec."Source Type" = Rec."Source Type"::Vendor then begin
            if rVendor.GET(Rec."Source No.") then
                SourceName := rVendor.Name;
        end;
        if Rec.Description = '' then begin
            if (rItem.Get((rec."Item No."))) then
                Rec.Description := rItem.Description;
        end;
    end;
}
