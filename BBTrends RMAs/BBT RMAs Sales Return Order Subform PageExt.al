PageExtension 51202 "RMAs Sales Return Subform" extends "Sales Return Order Subform"
{
    layout
    { }

    actions
    {
        addafter("Order &Tracking")
        {
            action(Packages)
            {
                ApplicationArea = All;
                Caption = 'Return Packages', Comment = 'ESP="Bultos Devolución"';
                Ellipsis = false;
                Image = Inventory;

                RunObject = Page "RMAs Package Line List";
                RunPageLink = "Return Order No." = field("Document No."), "Item No." = field("No.");
                RunPageMode = View;

                trigger OnAction()
                var
                begin
                end;
            }
        }
    }
}