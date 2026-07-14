page 51218 "RMAs Management Activities"
{
    Caption = 'Activities', Comment = 'ESP="Actividades"';
    PageType = CardPart;
    RefreshOnActivate = true;
    ApplicationArea = All;
    SourceTable = "RMAs Cue";
    Permissions = tabledata "RMAs Cue" = rm;

    layout
    {
        area(content)
        {
            cuegroup("Return Packages")
            {
                Caption = 'Return Packages', Comment = 'ESP="Bultos Devolución"';
                field("RMAs Package - Open"; Rec."RMAs Package - Open")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "RMAs Package Open List";
                }
                field("RMAs Package - Closed"; Rec."RMAs Package - Closed")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "RMAs Package Closed List";
                }
                field("RMAs Package - Posted Pending Qty"; Rec."RMAs Package - Pending Qty")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "RMAs Units Pending Returns";
                }
            }
            cuegroup("Posted Packages")
            {
                Caption = 'Posted Packages', Comment = 'ESP="Bultos Registrados"';
                field("Posted Package"; Rec."Package registered")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "RMAs Posted Package List";
                }
            }
            cuegroup("Transferred Packages")
            {
                Caption = 'Package to be Transferred', Comment = 'ESP="Bultos a Transferir"';
                field("Line Pendig Transfer"; Rec."Line Pendig Transfer")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "RMAs Units Pending Transfer";
                }
                field("Package to be transferred"; Rec."Package to be transferred")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "RMAs Stock Package List";
                }
            }
            cuegroup("Transfer Orders")
            {
                Caption = 'Transfer Orders', Comment = 'ESP="Pedidos Transferencia"';
                field("RMAs Transfer Orders"; Rec."Transfer Orders")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Transfer Orders";
                }
            }
            cuegroup("Pending Cr Memos")
            {
                Caption = 'Pending Cr Memos', Comment = 'ESP="Abonos Pendientes"';
                field("Units Pendig Cr Memo"; Rec."Units Pendig Cr Memo")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "RMAs Units Pending Credit Memo";
                }
            }
        }
    }

    actions
    { }

    trigger OnOpenPage()
    var
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}

