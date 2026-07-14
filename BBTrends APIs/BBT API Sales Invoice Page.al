page 51420 "API Sales Invoice"
{
    PageType = API;
    Caption = 'API Sales Invoice';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apisalesinvoice';
    EntitySetName = 'apisalesinvoices';
    SourceTable = "Sales Invoice Line";
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    DelayedInsert = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No; Rec."Document No.")
                { }
                field(Sell_to_Customer_No; Rec."Sell-to Customer No.")
                { }
                field(Posting_Date; Rec."Posting Date")
                { }
                field(Currency_Code; CurrencyCode)
                { }
                field(Currency_Factor; CurrencyFactor)
                { }
                field(External_Document_No_; ExternalDocument)
                { }
                field(Line_No; Rec."Line No.")
                { }
                field("Type"; Rec.Type)
                { }
                field(ItemNo; Rec."No.")
                {
                    Caption = 'ItemNo', Comment = 'ESP="NoProducto"';
                }
                field(Location_Code; Rec."Location Code")
                { }
                field(Posting_Group; Rec."Posting Group")
                { }
                field(Shipment_Date; Rec."Shipment Date")
                { }
                field(Description; Rec.Description)
                { }
                field(Description_2; Rec."Description 2")
                { }
                field(Unit_of_Measure; Rec."Unit of Measure")
                { }
                field(Quantity; Rec.Quantity)
                { }
                field(Unit_Price; Rec."Unit Price")
                { }
                field(Unit_Cost_LCY; Rec."Unit Cost (LCY)")
                { }
                field(VAT; Rec."VAT %")
                { }
                field(Line_Discount; Rec."Line Discount %")
                { }
                field(Line_Discount_Amount; Rec."Line Discount Amount")
                { }
                field(Amount; Rec.Amount)
                { }
                field(Amount_Including_VAT; Rec."Amount Including VAT")
                { }
                field(Gross_Weight; Rec."Gross Weight")
                { }
                field(Net_Weight; Rec."Net Weight")
                { }
                field(Unit_Volume; Rec."Unit Volume")
                { }
                field(Shortcut_Dimension_1_Code; Rec."Shortcut Dimension 1 Code")
                { }
                field(Shortcut_Dimension_2_Code; Rec."Shortcut Dimension 2 Code")
                { }
                field(Customer_Price_Group; Rec."Customer Price Group")
                { }
                field(Shipment_No; ShipmentNo)
                { }
                field(Shipment_Line_No; ShipmentLineNo)
                { }
                field(Gen_Bus_Posting_Group; Rec."Gen. Bus. Posting Group")
                { }
                field(Gen_Prod_Posting_Group; Rec."Gen. Prod. Posting Group")
                { }
                field(VAT_Bus_Posting_Group; Rec."VAT Bus. Posting Group")
                { }
                field(VAT_Prod_Posting_Group; Rec."VAT Prod. Posting Group")
                { }
                field(VAT_Base_Amount; Rec."VAT Base Amount")
                { }
                field(Unit_Cost; Rec."Unit Cost")
                { }
                field(Line_Amount; Rec."Line Amount")
                { }
                field(VAT_Identifier; Rec."VAT Identifier")
                { }
                field(Qty_per_Unit_of_Measure; Rec."Qty. per Unit of Measure")
                { }
                field(Unit_of_Measure_Code; Rec."Unit of Measure Code")
                { }
                field(Quantity_Base; Rec."Quantity (Base)")
                { }
                field(Item_Category_Code; Rec."Item Category Code")
                { }
                field(Order_No_; Rec."Order No.")
                { }
            }
        }
    }

    var
        CurrencyCode: Code[10];
        CurrencyFactor: Decimal;
        ExternalDocument: Code[35];
        ShipmentNo: Code[20];
        ShipmentLineNo: Integer;
        rSalesInvoice: Record "Sales Invoice Header";
        rValueEntryAux: Record "Value Entry";
        rItemLedgerEtry: record "Item Ledger Entry";

    trigger OnOpenPage();
    begin
        Rec.SETFILTER(Quantity, '<> %1', 0);
        //Rec.SetFilter("Posting Date", '>%1', DMY2Date(01, 01, 2026));
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(CurrencyCode);
        Clear(CurrencyFactor);
        Clear(ExternalDocument);
        Clear(ShipmentNo);

        rSalesInvoice.Reset();
        rSalesInvoice.SetRange("No.", Rec."Document No.");
        if rSalesInvoice.FindFirst() then begin
            ExternalDocument := rSalesInvoice."External Document No.";
            CurrencyFactor := rSalesInvoice."Currency Factor";
            CurrencyCode := rSalesInvoice."Currency Code";
            if Currencycode = '' then
                CurrencyCode := Format('EUR');
        end;

        rValueEntryAux.Reset();
        rValueEntryAux.SetCurrentKey("Document No.");
        rValueEntryAux.SetRange("Item Ledger Entry Type", rValueEntryAux."Item Ledger Entry Type"::Sale);
        rValueEntryAux.SetRange("Source Code", 'VENTAS');
        rValueEntryAux.SetRange("Source Type", rValueEntryAux."Source Type"::Customer);
        rValueEntryAux.SetRange("Source No.", Rec."Sell-to Customer No.");
        rValueEntryAux.SetRange("Document Type", rValueEntryAux."Document Type"::"Sales Invoice");
        rValueEntryAux.SetRange("Item No.", Rec."No.");
        rValueEntryAux.SetRange("Document No.", Rec."Document No.");
        rValueEntryAux.SetRange("Document Line No.", Rec."line No.");
        IF rValueEntryAux.FindFirst() THEN BEGIN
            rItemLedgerEtry.Reset();
            rItemLedgerEtry.SetRange("Entry No.", rValueEntryAux."Item Ledger Entry No.");
            rItemLedgerEtry.SetRange("Entry Type", rValueEntryAux."Item Ledger Entry Type"::Sale);
            rItemLedgerEtry.SetRange("Document Type", rValueEntryAux."Document Type"::"Sales Shipment");
            rItemLedgerEtry.SetRange("Item No.", rValueEntryAux."Item No.");
            rItemLedgerEtry.SetRange("Source Type", rValueEntryAux."Source Type");
            rItemLedgerEtry.SetRange("Source No.", rValueEntryAux."Source No.");
            IF rItemLedgerEtry.FindFirst() THEN BEGIN
                ShipmentNo := rItemLedgerEtry."Document No.";
                ShipmentLineNo := rItemLedgerEtry."Document Line No.";
            END;
        END;
    end;
}
