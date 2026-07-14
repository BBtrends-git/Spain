PageExtension 51200 "RMAs Sales Return Order List" extends "Sales Return Order List"
{
    layout
    { }

    actions
    {
        addafter(CustomerStatistics)
        {
            action(Packages)
            {
                ApplicationArea = All;
                Caption = 'Return Packages', Comment = 'ESP="Bultos Devolución"';
                Ellipsis = false;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category5;
                Image = ServiceItem;

                RunObject = Page "RMAs Package Line List";
                RunPageLink = "Return Order No." = field("No.");
                RunPageMode = View;

                trigger OnAction()
                var
                begin
                end;
            }
        }
        // No se permite registrar desde la lista de devoluciones
        modify("P&osting")
        {
            Visible = false;
        }
    }
}
