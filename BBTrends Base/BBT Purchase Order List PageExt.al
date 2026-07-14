PageExtension 50230 "BBT Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Completely Received"; Rec."Completely Received")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Completely Received")
        {
            field("BBT ETA Planning"; rec."BBT ETA Planning")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("BBT ETD PI"; rec."BBT ETD PI")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("BBT Due Date ETD PI"; rec."BBT Due Date ETD PI")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("BBT Proforma"; Rec."BBT Proforma")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("BBT ETD LC"; rec."BBT ETD LC")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("BBT LC Date Received"; rec."BBT LC Date Received")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("BBT LC No"; rec."BBT LC No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("BBT LC Opening Date"; Rec."BBT LC Opening Date")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("BBT LC Status"; Rec."BBT LC Status")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("BBT Bank"; Rec."BBT Bank")
            {
                ApplicationArea = Basic;
                Caption = 'LC Bank', Comment = 'ESP="Banco LC"';
                Visible = false;
            }
        }
        addlast(factboxes)
        {
            part(PurchOrderCommentFactBox; "BBT Purchase Order Com FactBox")
            {
                ApplicationArea = all;
                Editable = true;
                SubPageLink = "No." = field("No."), "Document Type" = field("Document Type");
            }
        }
    }
    actions
    {
        addafter(Category_Category8)
        {
            actionref("EstadoImportación_Promoted01"; "EstadoImportación")
            { }
        }
        addfirst(processing)
        {
            action(EstadoImportación)
            {
                ApplicationArea = All;
                Caption = 'Import Purchase Status', Comment = 'ESP="Estado Pedidos Importación"';
                Ellipsis = false;
                Image = OrderPromisingSetup;
                trigger OnAction()
                var
                    rPurchaseSetup: Record "Purchases & Payables Setup";
                    rImportOrderStatus: Record "BBT Import Order Status";
                    rPurchaseHeaderSelec: Record "Purchase Header";
                    rPurchaseLineSelec: Record "Purchase Line";
                begin
                    rImportOrderStatus.InitializeRecord(SessionId(), rImportOrderStatus);
                    rImportOrderStatus.Reset();

                    rPurchaseSetup.Get();
                    rPurchaseSetup.TestField("BBT Vend. Post. Gr. Imp. Ord.");

                    CurrPage.SetSelectionFilter(rPurchaseHeaderSelec);
                    //rPurchaseHeaderSelec.SetRange("Gen. Bus. Posting Group", rPurchaseSetup."BBT Vend. Post. Gr. Imp. Ord.");
                    rPurchaseHeaderSelec.SetRange("Completely Received", false);
                    if rPurchaseHeaderSelec.FindSet() then
                        repeat
                            If not rPurchaseHeaderSelec."Include Import Status" then begin
                                //Selección estandar de lineas de pedidos de importación productos acabados (Item Category)
                                rPurchaseLineSelec.Reset();
                                rPurchaseLineSelec.SetRange("Document Type", rPurchaseHeaderSelec."Document Type");
                                rPurchaseLineSelec.SetRange("Document No.", rPurchaseHeaderSelec."No.");
                                rPurchaseLineSelec.SetRange(Type, rPurchaseLineSelec.Type::Item);
                                rPurchaseLineSelec.SetFilter("Item Category Code", '1*|2*|3*|4*|5*|6*|7*|8*');
                                rPurchaseLineSelec.SetFilter("Qty. to Receive", '<>%1', 0);
                                rPurchaseLineSelec.SetRange("Gen. Bus. Posting Group", rPurchaseSetup."BBT Vend. Post. Gr. Imp. Ord.");
                                if rPurchaseLineSelec.FindSet() then
                                    repeat
                                        //rImportOrderStatutes.MoveData(rImportOrderStatutes, rPurchaseLineSelec);
                                        rImportOrderStatus.MoveData(SessionId(), rImportOrderStatus, rPurchaseLineSelec);
                                    until rPurchaseLineSelec.Next() = 0;
                            end
                            //Selección Especial de lineas de pedidos de importación para productos diversos
                            else begin
                                rPurchaseLineSelec.Reset();
                                rPurchaseLineSelec.SetRange("Document Type", rPurchaseHeaderSelec."Document Type");
                                rPurchaseLineSelec.SetRange("Document No.", rPurchaseHeaderSelec."No.");
                                rPurchaseLineSelec.SetRange(Type, rPurchaseLineSelec.Type::Item);
                                rPurchaseLineSelec.SetFilter("Qty. to Receive", '<>%1', 0);
                                //rPurchaseLineSelec.SetRange("Gen. Bus. Posting Group", rPurchaseSetup."BBT Vend. Post. Gr. Imp. Ord.");
                                if rPurchaseLineSelec.FindSet() then
                                    repeat
                                        //rImportOrderStatutes.MoveData(rImportOrderStatutes, rPurchaseLineSelec);
                                        rImportOrderStatus.MoveData(SessionId(), rImportOrderStatus, rPurchaseLineSelec);
                                    until rPurchaseLineSelec.Next() = 0;
                            end;
                        until rPurchaseHeaderSelec.Next() = 0;

                    // SOLO los registros de la sesión actual
                    //rImportOrderStatus.Reset();
                    //rImportOrderStatus.SetRange("BBT Session Id", SessionId());
                    //if rImportOrderStatus.FindSet() then;

                    if rImportOrderStatus.IsEmpty then
                        Error('La selección no contiene pedidos con datos de importación')
                    else
                        Page.Run(Page::"BBT Import Order Status", rImportOrderStatus);
                end;
            }
        }
    }
}
