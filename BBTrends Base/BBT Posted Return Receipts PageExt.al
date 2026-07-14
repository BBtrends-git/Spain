pageextension 51139 "BBT Posted Ret Receipts Ext" extends "Posted Return Receipts"
{

    layout
    {
        addafter("No.")
        {
            field(ReturnOrderNo; Rec."Return Order No.")
            {
                ApplicationArea = All;
                visible = true;
            }

        }
        addafter("Sell-to Customer Name")
        {
            field(ReasonCode; Rec."Reason Code")
            {
                ApplicationArea = All;
                visible = true;
            }
            field(ReturnOrderDesc; rReasonCode.Description)
            {
                Caption = 'Reason Code Description', Comment = 'ESP="Descripción Devolución"';
                ApplicationArea = All;
                visible = true;
            }
        }
        modify("Currency Code")
        {
            Visible = false;
        }
    }

    var
        rReasonCode: record "Reason Code";

    trigger OnAfterGetRecord()
    begin
        Clear(rReasonCode);
        if rReasonCode.get(rec."Reason Code") then;
    end;
}