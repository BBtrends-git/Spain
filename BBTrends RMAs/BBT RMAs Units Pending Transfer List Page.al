Page 51234 "RMAs Units Pending Transfer"
{
    Caption = 'Units Pending to Transfer', Comment = 'ESP="Unidades Pendientes de Transferir"';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "RMAs Posted Package Line";
    ApplicationArea = All;
    ModifyAllowed = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = false;
    Editable = true;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posted Package No."; Rec."Posted Package No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posted No."; Rec."Posted No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posted Package Line"; Rec."Posted Package Line")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quality; Rec.Quality)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transferred Quantity"; Rec."Transferred Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    { }

    var
        rRMASetup: Record "RMAs Setup";

    trigger OnOpenPage()
    begin
        rRMASetup.Reset();
        rRMASetup.Get();
        Rec.SetRange("Fully Transferred", false);
        Rec.SetFilter(Quantity, '>%1', 0);
        if rRMASetup."Scrap Adjust" then
            Rec.SetFilter(Quality, '%1|%2', Rec.Quality::A, rec.Quality::B);
    end;

}