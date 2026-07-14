PageExtension 50241 "BBT Docs. in BG Subform" extends "Docs. in BG Subform"
{
    layout
    {
        addafter("Category Code")
        {
            field("Nombre Cliente"; Rec."Nombre Cliente")
            {
                ApplicationArea = Basic;
            }
            field("Nombre Proveedor"; Rec."Nombre Proveedor")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
