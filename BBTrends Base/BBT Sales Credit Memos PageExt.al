pageextension 51130 "BBT Sales Credit Memos Ext" extends "Sales Credit Memos"
{
    layout
    {
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Status")
        {
            Visible = true;
        }
        addafter("Status")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = Suite;
                Caption = 'Reason Code', Comment = 'ESP="Cód. auditoría"';
                Importance = Standard;
            }
            field("EDI order"; Rec."EDI - EDI Order")
            {
                ApplicationArea = Suite;
                Caption = 'EDI Document', Comment = 'ESP="Documento EDI"';
                Importance = Standard;
            }
        }
    }
}