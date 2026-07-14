page 51216 "RMAs Stock Package Selection"
{
    AutoSplitKey = true;
    Caption = 'RMAs Stock Package Selection', Comment = 'ESP="RMA Selección de Existencia"';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    PageType = ListPart;
    SourceTable = "RMAs Package Transfer Matrix";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Package Line"; Rec."Package Line")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Original Posted Package No."; Rec."Original Posted Package No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Original Posted No."; Rec."Original Posted No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Original Posted Package Line"; Rec."Original Posted Package Line")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("EAN of Unit"; Rec."EAN of Unit")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(QuantityToTransfer; Rec."Quantity to Transfer")
                {
                    ApplicationArea = All;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        case true of
                            Rec."Quantity to Transfer" > rec.Quantity:
                                Error(Error01);
                            Rec."Quantity to Transfer" < 0:
                                Error(Error02);
                            else begin
                                rRMAsStockPackageLine.ManageRMAStockPackageLine(Rec, Rec."Package No.", Rec."Quantity to Transfer");
                            end;
                        end;
                        CurrPage.Update();
                    end;
                }
            }
        }
    }
    actions
    {
        /*
        area(processing)
        {
            action(Package)
            {
                ApplicationArea = Basic;
                Caption = 'Package Return', comment = 'ESP="Bulto Devolución"';
                Image = Inventory;
                Ellipsis = false;
                RunObject = Page "RMAs Package Card";
                RunPageLink = "Package No." = field("Package No.");
                RunPageMode = View;
            }
            action(DocReturn)
            {
                ApplicationArea = All;
                Caption = 'Document Return', Comment = 'ESP="Devolución"';
                Ellipsis = false;
                Image = Documents;
                Enabled = (Rec."Return Order No." <> '');
                RunObject = Page "Sales Return Order";
                RunPageLink = "No." = field("Return Order No.");
                RunPageMode = View;
            }
        }
        */
    }
    var
        //rRMAsPackage: Record "RMAs Package";
        //rRMAsPackageLine: Record "RMAs Package Line";
        //rRMAsStockPackage: Record "RMAs Stock Package";
        rRMAsStockPackageLine: Record "RMAs Stock Package Line";
        // rRMATransferMatrix: Record "RMAs Package Transfer Matrix";

        //RemainingQuantity: Integer;

        Error01: Label 'The selected quantity cannot be greater than the original quantity',
            Comment = 'ESP="La cantidad seleccionada no puede ser mayor que la original"';
        Error02: Label 'The quantity cannot be negative.',
            Comment = 'ESP="La cantidad no puede ser negativa"';
    /*
        trigger OnAfterGetRecord()
        begin
            rRMAsPackageLine.Reset();
            rRMAsPackageLine.SetRange("Package No.", Rec."Original Package No.");
            rRMAsPackageLine.setRange("Package Line", Rec."Original Package Line");
            if rRMAsPackageLine.FindFirst() then begin
                rRMAsPackageLine.CalcFields("Transferred Quantity");
                RemainingQuantity := rRMAsPackageLine.Quantity - rRMAsPackageLine."Transferred Quantity";
            end;
        end;
    */
}