pageextension 50007 "BBT Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Expense Note Nos."; Rec."Expense Note Nos.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Number Series")
        {
            group("Import Orders")
            {
                Caption = 'Import Orders', comment = 'ESP="Importación pedidos"';

                field("BBT Vend. Post. Gr. Imp. Ord."; Rec."BBT Vend. Post. Gr. Imp. Ord.")
                {
                    ApplicationArea = All;
                }
                field("Item Cat Code Filt. Imp Order"; Rec."Item Cat Code Filt. Imp Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat Code Filt. Imp Order field.', Comment = 'ESP="Filtro categoria producto"';
                }
            }
        }
    }
}
