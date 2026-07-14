Page 50024 "Pending Purchase Receipt Lines"
{
    Caption = 'Pending Purchase Receipt Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData "Purch. Rcpt. Line" = rm;
    SourceTable = "Purch. Rcpt. Line";
    SourceTableView = where("Qty. Rcd. Not Invoiced" = filter(<> 0));
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    HideValue = "Document No.HideValue";
                    StyleExpr = 'Strong';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Editable = false;
                    Lookup = false;
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Importe Compra"; ImptCompra)
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount', comment = 'ESP="Importe"';
                    Editable = false;
                }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if Rec."Qty. Rcd. Not Invoiced" < 0 then Error(Error001);
                        if Rec."Qty. Rcd. Not Invoiced" > (Rec.Quantity - Rec."Quantity Invoiced") then Error(Error002, (Rec.Quantity - Rec."Quantity Invoiced"));
                        Rec."Quantity Invoiced" := Rec.Quantity - Rec."Qty. Rcd. Not Invoiced";
                        Rec."Qty. Invoiced (Base)" := Rec."Quantity Invoiced" * Rec."Qty. per Unit of Measure";
                        ImptRecibido := Rec."Qty. Rcd. Not Invoiced" * CosteUnitarioDirecto;
                        ImptFacturado := Rec."Quantity Invoiced" * CosteUnitarioDirecto;
                        Rec.Modify;
                    end;
                }
                field("Importe Recibido"; ImptRecibido)
                {
                    ApplicationArea = Basic;
                    Caption = 'Received Amount not Invoiced';
                    Editable = false;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Importe Facturado"; ImptFacturado)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Amount';
                    Editable = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;

                action("Show Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PurchRcptHeader.Get(Rec."Document No.");
                        Page.Run(Page::"Posted Purchase Receipt", PurchRcptHeader);
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action("Item &Tracking Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        Rec.ShowItemTrackingLines;
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        PurchaseLine.SetRange("Document Type", 1);
        PurchaseLine.SetRange("Document No.", Rec."Order No.");
        PurchaseLine.SetRange("Line No.", Rec."Order Line No.");
        PurchaseLine.SetRange("Buy-from Vendor No.", Rec."Buy-from Vendor No.");
        if PurchaseLine.FindFirst() then begin
            CosteUnitarioDirecto := PurchaseLine."Direct Unit Cost";
            ImptCompra := Rec.Quantity * CosteUnitarioDirecto;
            ImptRecibido := Rec."Qty. Rcd. Not Invoiced" * CosteUnitarioDirecto;
            ImptFacturado := Rec."Quantity Invoiced" * CosteUnitarioDirecto;
        end;
    end;

    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        TempPurchRcptLine: Record "Purch. Rcpt. Line" temporary;
        GetReceipts: Codeunit "Purch.-Get Receipt";
        "Document No.HideValue": Boolean;
        PurchaseLine: Record "Purchase Line";
        CosteUnitarioDirecto: Decimal;
        ImptCompra: Decimal;
        ImptRecibido: Decimal;
        ImptFacturado: Decimal;
        Error001: label 'The amount received not invoiced can not be less than 0';
        Error002: label 'The amount received not invoiced can not be greater than %1';
}
