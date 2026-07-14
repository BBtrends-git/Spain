page 51224 "RMAs Item List"
{
    ApplicationArea = All;
    Caption = 'Items', Comment = 'ESP="Productos"';
    CardPageID = "RMAS Item Card";
    PageType = List;
    QueryCategory = 'Item List';
    SourceTable = Item;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Caption = 'Item', Comment = 'ESP="Producto"';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("EAN Code"; Rec."EAN Code")
                {
                    ApplicationArea = ALL;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Item Group"; Rec."Item Group")
                {
                    ApplicationArea = All;
                }
                field("Item Family"; Rec."Item Family")
                {
                    ApplicationArea = All;
                }
                field("Item Subfamily"; Rec."Item Subfamily")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture', comment = 'ESP="Imagen"';
                SubPageLink = "No." = field("No.");
            }
            part(ReturnCommentFaxbox; "RMAs Item Comment Lines Faxbox")
            {
                ApplicationArea = Suite;
                SubPageLink = "Table Name" = filter(Item), "No." = field("No.");
            }
        }
    }
    actions
    {
        area(processing)
        { }
        area(reporting)
        { }
        area(navigation)
        { }
        area(Promoted)
        { }
    }

}