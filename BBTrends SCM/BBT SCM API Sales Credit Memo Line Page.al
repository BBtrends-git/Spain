page 51258 "SCM API Sales CrMemo Line"
{
    PageType = API;
    Caption = 'SCM CrMemo Line';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtscm';
    APIVersion = 'v2.0';
    EntityName = 'scmcrmemoline';
    EntitySetName = 'scmcrmemolines';
    SourceTable = "Sales Cr.Memo Line";
    Editable = false;
    DelayedInsert = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document"; Rec."Document No.")
                { }
                field("Line"; Rec."Line No.")
                { }
                field("Date"; Rec."Posting Date")
                { }
                field("Customer"; Rec."Sell-to Customer No.")
                { }
                field("Warehouse"; Rec."Location Code")
                { }
                field("Item"; Rec."No.")
                { }
                field("Quantity"; Quantity)
                { }
                field("Amount"; LineAmount)
                { }
            }
        }
    }
    var
        Quantity: Decimal;
        LineAmount: Decimal;

    trigger OnInit()
    begin
        Rec.SetRange(Type, Rec.Type::Item);
        Rec.SetFilter(Quantity, '<>%1', 0);
        Rec.SetFilter("Document No.", 'AV*');
    end;

    trigger OnAfterGetRecord()
    begin
        Quantity := Rec.Quantity;
        LineAmount := Rec."Line Amount";
    end;
}