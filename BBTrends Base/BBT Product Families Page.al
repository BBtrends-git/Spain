Page 51101 "BBT Product Families"
{
    Caption = 'Product Families', Comment = 'ESP="Familias de Producto"';
    PageType = List;
    SourceTable = "Product Families";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Classification field"; Rec."Classification Field")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        ParentValueEnabled := false;
                        if Rec."Classification Field" <> Rec."Classification Field"::"Item Group" then
                            ParentValueEnabled := true;
                    end;
                }
                field("Classification Value"; Rec."Classification Value")
                {
                    ApplicationArea = Basic;
                }
                field("Parent Value"; Rec."Parent Value")
                {
                    ApplicationArea = Basic;
                    Enabled = ParentValueEnabled;
                    Editable = ParentValueEnabled;
                    trigger OnValidate()
                    var
                        _ProductFamilies: Record "Product Families";
                        Error_01: Label 'The product group does not allow higher level', Comment = 'ESP="Es necesario indicar el valor del nivel superior"';
                        Error_02: Label 'It is necessary to indicate the value of the highest level', Comment = 'ESP="Es necesario indicar el valor del nivel superior"';
                        Error_03: Label 'The %1 %2 does not exist', Comment = 'ESP="La %2 %1 no existe"';
                    begin
                        Clear(_ProductFamilies);
                        Case Rec."Classification field" of
                            Rec."Classification field"::"Item Family":
                                begin
                                    if Rec."Parent Value" = '' then
                                        Error(Error_02);

                                    _ProductFamilies.SetRange("Classification Field", Rec."Classification field"::"Item Group");
                                    _ProductFamilies.SetRange("Classification Value", Rec."Parent Value");
                                    if NOT _ProductFamilies.FindFirst() then
                                        Error(Error_03, Rec."Parent Value", Rec."Classification field"::"Item Group");
                                end;
                            Rec."Classification field"::"Item Subfamily":
                                begin
                                    if Rec."Parent Value" = '' then
                                        Error(Error_02);

                                    _ProductFamilies.SetRange("Classification Field", Rec."Classification field"::"Item Family");
                                    _ProductFamilies.SetRange("Classification Value", Rec."Parent Value");
                                    if NOT _ProductFamilies.FindFirst() then
                                        Error(Error_03, Rec."Parent Value", Rec."Classification field"::"Item Family");
                                end;

                            else // Item Group
                                if Rec."Parent Value" <> '' then
                                    Error(Error_01);

                        End;
                    end;
                }

            }
        }
    }
    actions
    {
    }
    var
        ParentValueEnabled: Boolean;
    /*
        trigger OnOpenPage()
        begin
            ParentValueEnabled := false;
        end;
    */
    trigger OnAfterGetRecord()
    begin
        ParentValueEnabled := false;
        if Rec."Classification Field" <> Rec."Classification Field"::"Item Group" then
            ParentValueEnabled := true;
    end;
}