Page 50037 "Packagings List"
{
    Caption = 'Embalajes';
    InsertAllowed = false;
    PageType = List;
    SourceTable = Packaging;
    UsageCategory = Documents;
    ApplicationArea = all;
    CardPageId = "Packaging Card";

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
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Created by"; Rec."Created by")
                {
                    ApplicationArea = Basic;
                }
                field("Posted by"; Rec."Posted by")
                {
                    ApplicationArea = Basic;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posted Source No."; Rec."Posted Source No.")
                {
                    ApplicationArea = Basic;
                }
                field("Gross Weight 1 (AAD)"; Rec."Gross Weight 1 (AAD)")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(New)
            {
                ApplicationArea = All;
                Caption = 'New', comment = 'ESP="Nuevo"';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    PackagingCard: Page "Packaging Card";
                    Packaging: Record Packaging;
                begin
                    Packaging.INIT;
                    Packaging.VALIDATE("Posted Source Type", SourceType);
                    Packaging.VALIDATE("Posted Source No.", SourceNo);
                    Packaging.INSERT(TRUE);
                    Commit();
                    CLEAR(PackagingCard);
                    PackagingCard.SETRECORD(Packaging);
                    PackagingCard.LOOKUPMODE(FALSE);
                    PackagingCard.RUNMODAL;
                end;
            }
        }
    }
    var SourceType: Integer;
    SourceNo: Code[20];
    SourceLineNo: Integer;
    LocationCode: Code[20];
    procedure SetSource(parSourceType: Integer; parSourceNo: Code[20]; parSourceLineNo: Integer)
    begin
        SourceType:=parSourceType;
        SourceNo:=parSourceNo;
        SourceLineNo:=parSourceLineNo;
    end;
    procedure SetLocationCode(parLocationCode: Code[20])
    begin
        LocationCode:=parLocationCode;
    end;
}
