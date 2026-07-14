PageExtension 51201 "RMAs Sales Return Order" extends "Sales Return Order"
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
                PromotedCategory = Process;
                Image = Inventory;

                RunObject = Page "RMAs Package Line List";
                RunPageLink = "Return Order No." = field("No.");
                RunPageMode = View;

                trigger OnAction()
                var
                begin
                end;
            }
        }

        modify("Post and &Print")
        {
            Visible = true;
            Enabled = vEnabled;
        }
        modify("Post &Batch")
        {
            Visible = true;
            Enabled = vEnabled;
        }
    }
    var
        vEnabled: Boolean;

    trigger OnAfterGetRecord()
    var
        rRMAPackageLine: record "RMAs Package Line";
        rRMAPostedPackageLine: record "RMAs Posted Package Line";
    begin
        vEnabled := true;
        rRMAPackageLine.Reset();
        rRMAPackageLine.SetRange("Return Order No.", Rec."No.");
        if rRMAPackageLine.findfirst then
            vEnabled := false
        else begin
            rRMAPostedPackageLine.Reset();
            rRMAPostedPackageLine.SetRange("Return Order No.", Rec."No.");
            if rRMAPostedPackageLine.FindFirst() then
                vEnabled := false;
        end;
    end;

}
