page 51220 "RMAs Transfer Matrix List"
{
    Caption = 'Matrix Lines', Comment = 'ESP="Líneas Matriz Transferencia"';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "RMAs Package Transfer Matrix";
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                }
                field("Package Line"; Rec."Package Line")
                {
                    ApplicationArea = All;
                }
                field("Original Posted Package No."; Rec."Original Posted Package No.")
                {
                    ApplicationArea = All;
                }
                field("Original Posted No."; Rec."Original Posted No.")
                {
                    ApplicationArea = All;
                }
                field("Destination Package Line"; Rec."Original Posted Package Line")
                {
                    ApplicationArea = All;
                }
                field("EAN of Unit"; Rec."EAN of Unit")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Quantity to Transfer"; Rec."Quantity to Transfer")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(Transferred; Rec.Transferred)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    /* RESETEO DE LA TABLA PARA PRUEBAS
    trigger OnClosePage()
    begin
        rec.DeleteAll();
    end;
    */
}
