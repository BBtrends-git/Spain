page 51257 "SCM API Sales Order Line"
{
    PageType = API;
    Caption = 'SCM Order Line';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtscm';
    APIVersion = 'v2.0';
    EntityName = 'scmorderline';
    EntitySetName = 'scmorderlines';
    SourceTable = "Sales Line";
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
                field("Date"; Rec."Shipment Date")
                { }
                field("Customer"; Rec."Sell-to Customer No.")
                { }
                field("Warehouse"; Rec."Location Code")
                { }
                field("Item"; Rec."No.")
                { }
                field("Quantity"; Rec."Outstanding Quantity")
                { }
                field("Amount"; Rec."Line Amount")
                { }
            }
        }
    }
    trigger OnInit()
    begin
        Rec.SetFilter("Document Type", '=%1', rec."Document Type"::Order);
        Rec.SetRange(Type, Rec.Type::Item);
        Rec.SetFilter(Quantity, '<>%1', 0);
        Rec.SetFilter("Outstanding Quantity", '<>%1', 0);
    end;
}