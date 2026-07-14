Table 51100 "Product Families"
{
    Caption = 'Product Families', Comment = 'ESP="Familias de Producto"';

    fields
    {
        field(51100; "Classification Field"; Option)
        {
            Caption = 'Classification Field', Comment = 'ESP="Campo de Clasificación"';

            OptionMembers = "Item Group","Item Family","Item Subfamily";
            OptionCaption = 'Item Group,Item Family,Item Subfamily', Comment = 'ESP="Grupo Producto,Familia Producto,Subfamilia Producto"';
        }
        field(51101; "Classification Value"; code[50])
        {
            Caption = 'Value Field', Comment = 'ESP="Valor Campo"';
        }
        field(51102; "Parent Value"; code[50])
        {
            Caption = 'Parent Value', Comment = 'ESP="Valor Padre"';
        }
    }

    keys
    {
        key(PK; "Classification field", "Classification Value", "Parent Value")
        { }
    }
    fieldgroups
    { }
    trigger OnDelete()
    var
        _ProductFamilies: Record "Product Families";
        Error_01: Label 'You cannot delete a %1 that has %2', Comment = 'ESP="No se puede borrar un %1 que tiene %2"';
    begin
        Case Rec."Classification field" of
            Rec."Classification field"::"Item Group":
                begin
                    _ProductFamilies.SetRange("Classification Field", Rec."Classification field"::"Item Family");
                    _ProductFamilies.SetRange("Parent Value", Rec."Classification Value");
                    if _ProductFamilies.FindFirst() then
                        Error(Error_01, Rec."Classification field"::"Item Group", Rec."Classification field"::"Item Family");
                end;
            Rec."Classification field"::"Item Family":
                begin
                    _ProductFamilies.SetRange("Classification Field", Rec."Classification field"::"Item Subfamily");
                    _ProductFamilies.SetRange("Parent Value", Rec."Classification Value");
                    if _ProductFamilies.FindFirst() then
                        Error(Error_01, Rec."Classification field"::"Item Family", Rec."Classification field"::"Item Subfamily");
                end;
        End;
    end;
}