PageExtension 50245 "BBT Docs. in Closed BG Subform" extends "Docs. in Closed BG Subform"
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
