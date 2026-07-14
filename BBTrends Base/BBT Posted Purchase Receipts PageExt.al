PageExtension 50143 "BBT Posted Purchase Receipts" extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = Basic;
            }
            field("Vendor Invoice Ref."; VendorInvoiceRef)
            {
                ApplicationArea = Basic;
                Caption = 'Invoice No.';
            }
        }
    }

    var
        VendorInvoiceRef: Text[50];
    /*rPurchInvHeader: Record "Purch. Inv. Header";
    rPurchInvLine: Record "Purch. Inv. Line";
    */
    //Unsupported feature: Code Insertion on "OnAfterGetRecord".
    //trigger OnAfterGetRecord()
    //begin
    /*
        CLEAR(VendorInvoiceRef);
        rPurchInvLine.RESET;
        rPurchInvLine.SETRANGE("Receipt No.","No.");
        IF rPurchInvLine.FINDFIRST THEN BEGIN
          rPurchInvHeader.RESET;
          rPurchInvHeader.SETRANGE("No.",rPurchInvLine."Document No.");
          IF rPurchInvHeader.FINDFIRST THEN
            VendorInvoiceRef := rPurchInvHeader."Vendor Invoice No.";
        END;
        */
    //end;
}
