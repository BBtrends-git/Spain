Page 51102 "BBT Lin Albaran Venta Upd"
{
    PageType = Card;
    SourceTable = "Sales Shipment Line";
    ModifyAllowed = True;
    DeleteAllowed = False;
    Editable = True;
    InsertAllowed = False;
    Permissions = TableData "Sales Shipment Line" = rim;
    layout
    {
        area(Content)
        {
            field("Description"; Rec."Description")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = true;
            }
        }
    }
    actions
    {
    }
    trigger OnModifyRecord(): Boolean
    begin
        if rec.Description <> xrec.Description then begin
            rec.Modify;
            COMMIT;
        end;
    end;
}
