Page 51235 "RMAs Units Pending Credit Memo"
{
    Caption = 'RMAs Units Pending Credit Memo', Comment = 'ESP="Unidades Devueltas Pendientes de Abono"';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Return Receipt Line";
    ApplicationArea = All;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = false;
    Editable = false;
    SourceTableView = sorting("Return Order No.", "Return Order Line No.") order(descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Return Order No."; Rec."Return Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Sell -to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."No.")
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
                field("Return Qty. Rcd. Not Invd."; Rec."Return Qty. Rcd. Not Invd.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty. to Invoice"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DocReturn)
            {
                ApplicationArea = All;
                Caption = 'Document', Comment = 'ESP="Devolución"';
                Ellipsis = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Documents;
                Enabled = (Rec."Return Order No." <> '');

                RunObject = Page "Sales Return Order";
                RunPageLink = "No." = field("Return Order No.");
                RunPageMode = View;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Type, rec.type::Item);
        Rec.SetFilter("Return Qty. Rcd. Not Invd.", '>%1', 0);
    end;
}