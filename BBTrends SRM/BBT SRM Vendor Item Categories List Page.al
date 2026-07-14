page 51355 "SRM Vendor Item Categories"
{
    ApplicationArea = All;
    Caption = 'Vendor Item Categories', comment = 'ESP="Categorias de Producto del Proveedor"';
    PageType = List;
    SourceTable = "SRM Vendor Item Categories";
    DeleteAllowed = true;
    ModifyAllowed = true;
    InsertAllowed = true;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Category)
            {
                ShowCaption = false;

                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        rItemCategory: Record "Item Category";
                    begin
                        Clear(Rec.Description);
                        if rItemCategory.Get(Rec."Code") then
                            Rec.Description := rItemCategory.Description;
                        CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}