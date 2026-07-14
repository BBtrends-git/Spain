page 51200 "RMAs Setup Card"
{
    ApplicationArea = Basic, Suite;
    Caption = 'RMA Setup', Comment = 'ESP="RMA Configuración"';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "RMAs Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';

                field("EAN13 Unit"; Rec."EAN13 Unit")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Resource Group"; Rec."Resource Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Return Series"; Rec."Return Series")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(LocationManagement)
            {
                Caption = 'Location Management', Comment = 'ESP="Gestión Almacén"';

                field("Adjustments Without Returns"; Rec."Adjustments Without Returns")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Returns Warehouse"; Rec."Returns Warehouse")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warehouse Quality A"; Rec."Warehouse Quality A")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warehouse Quality B"; Rec."Warehouse Quality B")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Scrap Adjust"; Rec."Scrap Adjust")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warehouse Quality C"; Rec."Warehouse Quality C")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = Not Rec."Scrap Adjust";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}