Page 50089 "36 csc"
{
    PageType = List;
    Permissions = TableData "Sales Header" = rimd;
    SourceTable = "Sales Header";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Name 2"; Rec."Bill-to Name 2")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Name 2"; Rec."Ship-to Name 2")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = Basic;
                }
                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                }
                field("Invoice Disc. Code"; Rec."Invoice Disc. Code")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    ApplicationArea = Basic;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = Basic;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic;
                }
                field("Order Class"; Rec."Order Class")
                {
                    ApplicationArea = Basic;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = Basic;
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = Basic;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Recalculate Invoice Disc."; Rec."Recalculate Invoice Disc.")
                {
                    ApplicationArea = Basic;
                }
                field(Ship; Rec.Ship)
                {
                    ApplicationArea = Basic;
                }
                field(Invoice; Rec.Invoice)
                {
                    ApplicationArea = Basic;
                }
                field("Print Posted Documents"; Rec."Print Posted Documents")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping No."; Rec."Shipping No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posting No."; Rec."Posting No.")
                {
                    ApplicationArea = Basic;
                }
                field("Last Shipping No."; Rec."Last Shipping No.")
                {
                    ApplicationArea = Basic;
                }
                field("Last Posting No."; Rec."Last Posting No.")
                {
                    ApplicationArea = Basic;
                }
                field("Prepayment No."; Rec."Prepayment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Last Prepayment No."; Rec."Last Prepayment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Prepmt. Cr. Memo No."; Rec."Prepmt. Cr. Memo No.")
                {
                    ApplicationArea = Basic;
                }
                field("Last Prepmt. Cr. Memo No."; Rec."Last Prepmt. Cr. Memo No.")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field("Combine Shipments"; Rec."Combine Shipments")
                {
                    ApplicationArea = Basic;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Country/Region Code"; Rec."VAT Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to County"; Rec."Bill-to County")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Exit Point"; Rec."Exit Point")
                {
                    ApplicationArea = Basic;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                }
                field("Package Tracking No."; Rec."Package Tracking No.")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping No. Series"; Rec."Shipping No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = Basic;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Basic;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Base Discount %"; Rec."VAT Base Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Invoice Discount Calculation"; Rec."Invoice Discount Calculation")
                {
                    ApplicationArea = Basic;
                }
                field("Invoice Discount Value"; Rec."Invoice Discount Value")
                {
                    ApplicationArea = Basic;
                }
                field("Send IC Document"; Rec."Send IC Document")
                {
                    ApplicationArea = Basic;
                }
                field("IC Status"; Rec."IC Status")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to IC Partner Code"; Rec."Sell-to IC Partner Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to IC Partner Code"; Rec."Bill-to IC Partner Code")
                {
                    ApplicationArea = Basic;
                }
                field("IC Direction"; Rec."IC Direction")
                {
                    ApplicationArea = Basic;
                }
                field("Prepayment %"; Rec."Prepayment %")
                {
                    ApplicationArea = Basic;
                }
                field("Prepayment No. Series"; Rec."Prepayment No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Compress Prepayment"; Rec."Compress Prepayment")
                {
                    ApplicationArea = Basic;
                }
                field("Prepayment Due Date"; Rec."Prepayment Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Prepmt. Cr. Memo No. Series"; Rec."Prepmt. Cr. Memo No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Prepmt. Posting Description"; Rec."Prepmt. Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field("Prepmt. Pmt. Discount Date"; Rec."Prepmt. Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                }
                field("Prepmt. Payment Terms Code"; Rec."Prepmt. Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field("Prepmt. Payment Discount %"; Rec."Prepmt. Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field("Quote No."; Rec."Quote No.")
                {
                    ApplicationArea = Basic;
                }
                field("Job Queue Status"; Rec."Job Queue Status")
                {
                    ApplicationArea = Basic;
                }
                field("Job Queue Entry ID"; Rec."Job Queue Entry ID")
                {
                    ApplicationArea = Basic;
                }
                field("Incoming Document Entry No."; Rec."Incoming Document Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                }
                /*
                field("Authorization Required"; Rec."Authorization Required")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Card No."; Rec."Credit Card No.")
                {
                    ApplicationArea = Basic;
                }
                */
                field("Direct Debit Mandate ID"; Rec."Direct Debit Mandate ID")
                {
                    ApplicationArea = Basic;
                }
                field("Invoice Discount Amount"; Rec."Invoice Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field("No. of Archived Versions"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                }
                field("Doc. No. Occurrence"; Rec."Doc. No. Occurrence")
                {
                    ApplicationArea = Basic;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer Template Code"; Rec."Sell-to Customer Templ. Code")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Customer Template Code"; Rec."Bill-to Customer Templ. Code")
                {
                    ApplicationArea = Basic;
                }
                field("Opportunity No."; Rec."Opportunity No.")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                    ApplicationArea = Basic;
                }
                field("Shipped Not Invoiced"; Rec."Shipped Not Invoiced")
                {
                    ApplicationArea = Basic;
                }
                field("Completely Shipped"; Rec."Completely Shipped")
                {
                    ApplicationArea = Basic;
                }
                field("Posting from Whse. Ref."; Rec."Posting from Whse. Ref.")
                {
                    ApplicationArea = Basic;
                }
                field("Location Filter"; Rec."Location Filter")
                {
                    ApplicationArea = Basic;
                }
                field(Shipped; Rec.Shipped)
                {
                    ApplicationArea = Basic;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Time"; Rec."Shipping Time")
                {
                    ApplicationArea = Basic;
                }
                field("Outbound Whse. Handling Time"; Rec."Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                }
                field("Late Order Shipping"; Rec."Late Order Shipping")
                {
                    ApplicationArea = Basic;
                }
                field("Date Filter"; Rec."Date Filter")
                {
                    ApplicationArea = Basic;
                }
                field(Receive; Rec.Receive)
                {
                    ApplicationArea = Basic;
                }
                field("Return Receipt No."; Rec."Return Receipt No.")
                {
                    ApplicationArea = Basic;
                }
                field("Return Receipt No. Series"; Rec."Return Receipt No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Last Return Receipt No."; Rec."Last Return Receipt No.")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic;
                }
                field("Get Shipment Used"; Rec."Get Shipment Used")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Corrected Invoice No."; Rec."Corrected Invoice No.")
                {
                    ApplicationArea = Basic;
                }
                field("Due Date Modified"; Rec."Due Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field("Invoice Type"; Rec."Invoice Type")
                {
                    ApplicationArea = Basic;
                }
                field("Cr. Memo Type"; Rec."Cr. Memo Type")
                {
                    ApplicationArea = Basic;
                }
                field("Special Scheme Code"; Rec."Special Scheme Code")
                {
                    ApplicationArea = Basic;
                }
                field("Operation Description"; Rec."Operation Description")
                {
                    ApplicationArea = Basic;
                }
                field("Correction Type"; Rec."Correction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Operation Description 2"; Rec."Operation Description 2")
                {
                    ApplicationArea = Basic;
                }
                field("Succeeded Company Name"; Rec."Succeeded Company Name")
                {
                    ApplicationArea = Basic;
                }
                field("Succeeded VAT Registration No."; Rec."Succeeded VAT Registration No.")
                {
                    ApplicationArea = Basic;
                }
                //>> BBT. SMG Extension. 
                /*
                field("Purchase Group"; Rec."Purchase Group")
                {
                    ApplicationArea = Basic;
                }
                */
                //<<
                field("Service Zone Code"; Rec."Service Zone Code")
                {
                    ApplicationArea = Basic;
                }
                field("Status SGA"; Rec."Status SGA")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Grabado SGA"; Rec."Grabado SGA")
                {
                    ApplicationArea = Basic;
                }
                field("Leido SGA"; Rec."Leido SGA")
                {
                    ApplicationArea = Basic;
                }
                field(ModificadoSGA; Rec.ModificadoSGA)
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Shipment cost payment"; Rec."EDI - Shipment cost payment")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Delivery condition"; Rec."EDI - Delivery condition")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Currency Code"; Rec."EDI - Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Unique due date"; Rec."EDI - Unique due date")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Total Amount"; Rec."EDI - Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Total discount/charges"; Rec."EDI - Total discount/charges")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Amount Base"; Rec."EDI - Amount Base")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Taxes amt."; Rec."EDI - Taxes amt.")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Paying amt."; Rec."EDI - Paying amt.")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Gross amt."; Rec."EDI - Gross amt.")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Comments"; Rec."EDI - Comments")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Additional info"; Rec."EDI - Additional info")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - EDI Order"; Rec."EDI - EDI Order")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Additional ref No."; Rec."EDI - Additional ref No.")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Do not send EDI"; Rec."EDI - Do not send EDI")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Document datetime"; Rec."EDI - Document datetime")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Delivery datetime"; Rec."EDI - Delivery datetime")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Shipping method"; Rec."EDI - Shipping method")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Shipping Agent Id."; Rec."EDI - Shipping Agent Id.")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Shipping Agent Name"; Rec."EDI - Shipping Agent Name")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Vehicle plate"; Rec."EDI - Vehicle plate")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Invoice message function"; Rec."EDI - Invoice message function")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Contract No."; Rec."EDI - Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Order Type"; Rec."EDI - Order Type")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Additional ref type"; Rec."EDI - Additional ref type")
                {
                    ApplicationArea = Basic;
                }
                field("EDI - Message function"; Rec."EDI - Message function")
                {
                    ApplicationArea = Basic;
                }
                field("Exclude packaging enforcement"; Rec."Exclude packaging enforcement")
                {
                    ApplicationArea = Basic;
                }
                field("Cód. Departamento"; Rec."Cód. Departamento")
                {
                    ApplicationArea = Basic;
                }
                field("Cód. Sucursal"; Rec."Cód. Sucursal")
                {
                    ApplicationArea = Basic;
                }
                field("Sales Shipment No."; Rec."Sales Shipment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Service No."; Rec."Customer Service No.")
                {
                    ApplicationArea = Basic;
                }
                field("Pedido Web/MarketPlace"; Rec."Pedido Web/MarketPlace")
                {
                    ApplicationArea = Basic;
                }
                // SMG Extension. 
                /*
                field("Blocked for Short Margin"; Rec."Blocked for Short Margin")
                {
                    ApplicationArea = Basic;
                }
                */

                field("Blocked for Short Margin"; Rec."SMG Blocked for Short Margin")
                {
                    ApplicationArea = Basic;
                }
                //<<
                field("PL VAT"; Rec."PL VAT")
                {
                    ApplicationArea = Basic;
                }
                field("Number of Packages"; Rec."Number of Packages")
                {
                    ApplicationArea = Basic;
                }
                field(Reference; Rec.Reference)
                {
                    ApplicationArea = Basic;
                }
                field("Applies-to Bill No."; Rec."Applies-to Bill No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cust. Bank Acc. Code"; Rec."Cust. Bank Acc. Code")
                {
                    ApplicationArea = Basic;
                }
                // field("Pay-at Code"; Rec."Pay-at Code")
                // {
                //     ApplicationArea = Basic;
                // }
            }
        }
    }
    actions
    {
    }
}
