page 51250 "SCM API Item"
{
    PageType = API;
    Caption = 'SCM Item';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtscm';
    APIVersion = 'v2.0';
    EntityName = 'scmitem';
    EntitySetName = 'scmitems';
    SourceTable = Item;
    Editable = false;
    DelayedInsert = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Codigo"; Rec."No.")
                { }
                field("Descripcion"; rec.Description)
                { }
                field("UnidaBase"; rec."Base Unit of Measure")
                { }
                field("TipoItem"; "TipoItem")
                { }
                field("Planificacion"; "Planificacion")
                { }
                field("Reposicion"; "Reposicion")
                { }
                field("Estado"; "Estado")
                { }
                field("Familia"; "Familia")
                { }
                field("Subfamilia"; "Subfamilia")
                { }
                field("Marca"; Rec."Global Dimension 2 Code")
                { }
                field("BloqueoCompra"; Rec."Purchasing Blocked")
                { }
                field("BloqueoVenta"; Rec."Sales Blocked")
                { }
                field(Categoria; rec."Item Category Code")
                { }
            }
        }
    }
    var
        TipoItem: Text[20];
        Estado: Text[20];
        Planificacion: Text[20];
        Reposicion: Text[20];
        Familia: Text[100];
        Subfamilia: Text[100];
        rItemCategory: Record "Item Category";
        rItemCategoryAux: Record "Item Category";
        rItemAux: Record Item;

    trigger OnInit()
    begin
    end;

    trigger OnAfterGetRecord()
    begin
        // Tipo de Item
        rItemAux.Reset();
        rItemAux.setRange("No.", rec."No.");
        ritemaux.SetFilter("Item Category Code", '1*|2*|3*|4*|5*|6*|7*|8*');
        if rItemAux.FindFirst() then
            TipoItem := 'Producto'
        else
            TipoItem := 'Material';

        // Planificación
        Planificacion := 'Contra Stock';
        if rec."Reordering Policy" = rec."Reordering Policy"::Order then
            Planificacion := 'Contra Pedido';
        if TipoItem <> 'Producto' then
            Planificacion := 'No Planificar';

        // Reposición
        Reposicion := 'Compra';
        if rec."Replenishment System" <> rec."Replenishment System"::Purchase then
            Reposicion := 'Producción';

        // Estado
        Estado := 'Activo';
        if rec.Blocked or Rec."Purchasing Blocked" or Rec."Sales Blocked" then
            Estado := 'Obsoleto';

        // Familia / Subfamilia
        Clear(Familia);
        Clear(Subfamilia);
        rItemCategory.Reset();
        rItemCategory.SetRange(Code, rec."Item Category Code");
        if rItemCategory.FindFirst() then begin
            Subfamilia := rItemCategory.Description;
            rItemCategoryAux.Reset();
            rItemCategoryAux.SetRange(Code, rItemCategory."Parent Category");
            if rItemCategoryAux.FindFirst() then
                Familia := rItemCategoryAux.Description;
        end;
    end;
}