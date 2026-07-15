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
            systempart(ItemLinks; Links)
            {
                ApplicationArea = RecordLinks;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Packaging_Residues)
            {
                Caption = 'Packaging and residues', Comment = 'ESP="Envases y residuos"';
                ApplicationArea = all;
                Image = Item;
                Enabled = UserExecute;
                Visible = UserExecute;

                trigger OnAction()
                var
                    glItemResidues: Page "BBT Item Residues";
                    rlItemResidues: Record "BBT Item Residues";
                begin
                    Clear(glItemResidues);
                    rlItemResidues.Reset();
                    rlItemResidues.SetRange("Item No.", Rec."No.");
                    glItemResidues.SetTableView(rlItemResidues);
                    glItemResidues.RunModal();
                end;
            }
        }
        area(navigation)
        { }
        area(reporting)
        { }
        area(Promoted)
        {
            actionref(PackagingResiduesPromoted; Packaging_Residues)
            { }
        }
    }

    var
        UserExecute: Boolean;

    trigger OnOpenPage()
    begin
        UserExecute := UserPermissions()
    end;

    local procedure UserPermissions(): Boolean
    var
        rAccessControl: Record "Access Control";
        rTenantPermission: Record "Tenant Permission";
    begin
        // 1. Si el usuario es SUPER, siempre habilitamos la acción
        rAccessControl.SetRange("User Security ID", UserSecurityId());
        rAccessControl.SetFilter("Company Name", '%1|%2', '', CompanyName);
        rAccessControl.SetRange("Role ID", 'SUPER');
        if not rAccessControl.IsEmpty() then
            exit(true);

        // 2. Buscamos en los roles del usuario si alguno tiene asignada la Page 50121
        rAccessControl.Reset();
        rAccessControl.SetRange("User Security ID", UserSecurityId());
        rAccessControl.SetFilter("Company Name", '%1|%2', '', CompanyName);
        if rAccessControl.FindSet() then
            repeat
                // Comprobamos permisos en extensiones (Tenant Permission)
                rTenantPermission.SetRange("Role ID", rAccessControl."Role ID");
                rTenantPermission.SetRange("Object Type", rTenantPermission."Object Type"::Page);
                rTenantPermission.SetRange("Object ID", 50121);      // "BBT Item Residues"

                if rTenantPermission.FindFirst() then begin
                    if rTenantPermission.Type <> rTenantPermission.Type::Exclude then
                        if rTenantPermission."Execute Permission" = rTenantPermission."Execute Permission"::Yes then
                            exit(true);
                end;

            until rAccessControl.Next() = 0;

        exit(false);
    end;
}