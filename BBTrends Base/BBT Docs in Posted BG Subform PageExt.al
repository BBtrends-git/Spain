PageExtension 50242 "BBT Docs. in Posted BG Subform" extends "Docs. in Posted BG Subform"
{
    layout
    {
        addafter(Place)
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
