page 51225 "RMAs Item Card"
{
    Caption = 'Item Card', Comment = 'ESP=Ficha Producto';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Item;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(Item)
            {
                Caption = 'Item', Comment = 'ESP="Producto"';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Visible = false;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
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
            }
            group(InventoryGrp)
            {
                Caption = 'Inventory', Comment = 'ESP="Inventario"';
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    ApplicationArea = All;
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    ApplicationArea = All;
                }

                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Visible = false;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Visible = false;
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Trans. Ord. Receipt (Qty.)"; Rec."Trans. Ord. Receipt (Qty.)")
                {
                    ApplicationArea = All;
                }
                field("Trans. Ord. Shipment (Qty.)"; Rec."Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = All;
                }
                field("Qty. in Transit"; Rec."Qty. in Transit")
                {
                    ApplicationArea = All;
                }
            }
            group(IdentifiersGrp)
            {
                Caption = 'Identifiers', Comment = 'ESP="Identificadores de Producto"';

                part(Identifiers; "RMAs Item Identifiers Subform")
                {
                    Caption = '', Comment = 'ESP=""';
                    ApplicationArea = All;
                    Enabled = true;
                    SubPageLink = "Item No." = field("No.");
                    UpdatePropagation = Both;
                    Editable = false;
                }
            }
            group(UnitOfMeasureGrp)
            {
                Caption = 'Units of Measure', Comment = 'ESP="Unidades de Medida"';

                part(UnitOfMeasure; "RMAs Units of Measure Subform")
                {
                    Caption = '', Comment = 'ESP=""';
                    ApplicationArea = All;
                    Enabled = true;
                    SubPageLink = "Item No." = field("No.");
                    UpdatePropagation = Both;
                    Editable = false;
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
        area(navigation)
        { }
        area(reporting)
        { }
        area(Promoted)
        { }
    }
}