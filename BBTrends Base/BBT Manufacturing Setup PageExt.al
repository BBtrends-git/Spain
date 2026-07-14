PageExtension 50251 "BBT Manufacturing Setup" extends "Manufacturing Setup"
{
    layout
    {
        addafter("Cost Incl. Setup")
        {
            //>> Obsoleto. SDA
            /*
            field("Automatic Consumptions"; Rec."Automatic Consumptions")
            {
                ApplicationArea = Basic;
            }
            field("Auto. Cons. Jnl. Tmpl. Name"; Rec."Auto. Cons. Jnl. Tmpl. Name")
            {
                ApplicationArea = Basic;
            }
            field("Auto. Cons. Jnl. Batch Name"; Rec."Auto. Cons. Jnl. Batch Name")
            {
                ApplicationArea = Basic;
            }
            */
            //<<
            field("Last MRP Calculation"; Rec."Last MRP Calculation")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Lote Producto Auto."; Rec."Lote Producto Auto.")
            {
                ApplicationArea = Basic;
            }
            field("Ruta PDF disenyo"; Rec."Ruta PDF disenyo")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        //addafter("Default Dampener %")        // Obsoleto
        addafter("Components at Location")
        {
            field("Req. calculate forecast"; Rec."Req. calculate forecast")
            {
                ApplicationArea = Basic;
            }
            field("Active sales budget"; Rec."Active sales budget")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
