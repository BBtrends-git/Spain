page 51252 "SCM API Sales Invoice Line"
{
    PageType = API;
    Caption = 'SCM Invoice Line';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtscm';
    APIVersion = 'v2.0';
    EntityName = 'scminvoiceline';
    EntitySetName = 'scminvoicelines';
    SourceTable = "Sales Invoice Line";
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
                field("Quantity"; Rec.Quantity)
                { }
                field("Amount"; Rec."Line Amount")
                { }
            }
        }
    }
    trigger OnInit()
    begin
        Rec.SetRange(Type, Rec.Type::Item);
        Rec.SetFilter(Quantity, '<>%1', 0);
        Rec.SetFilter("Document No.", 'FV*');
    end;

    trigger OnAfterGetRecord()
    begin
    end;
}