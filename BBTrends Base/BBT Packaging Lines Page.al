Page 50040 "Packaging Lines"
{
    Caption = 'Líneas Embalaje';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = 50020;
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posted Source No."; Rec."Posted Source No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posted Source Line No."; Rec."Posted Source Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            action("Ver embalaje")
            {
                ApplicationArea = Basic;
                Caption = 'Ver embalaje';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Packaging: Record 50005;
                begin
                    Rec.TestField("No.");
                    Clear(Packaging);
                    Packaging.Reset;
                    Packaging.SetRange("No.", Rec."No.");
                    Page.Run(Page::"Packaging Card", Packaging);
                end;
            }
        }
    }
}
