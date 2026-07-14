Page 50071 "Customer Service List"
{
    Caption = 'Servicios cliente';
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Customer Service Header";
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Service Datetime"; Rec."Service Datetime")
                {
                    ApplicationArea = Basic;
                }
                field("Communication Method"; Rec."Communication Method")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Contact E-Mail"; Rec."Sell-to Contact E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("End Datetime"; Rec."End Datetime")
                {
                    ApplicationArea = Basic;
                }
                field(Comment; CommentText)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comentarios';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("From NAV Doc Type"; Rec."From NAV Doc Type")
                {
                    ApplicationArea = Basic;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field("Service Type"; Rec."Service Type")
                {
                    ApplicationArea = Basic;
                }
                field("From NAV Doc. No."; Rec."From NAV Doc. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Package Tracking No."; Rec."Package Tracking No.")
                {
                    ApplicationArea = Basic;
                }
                field("Warehose Ship No."; Rec."Warehose Ship No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        CommentText := Rec.GetComment;
        if Rec."From NAV Doc. No." = '' then begin
            Rec."Shipment No." := '';
            Rec."Package Tracking No." := '';
        end;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Status, '%1|%2', Rec.Status::"In progress", Rec.Status::Started);
    end;

    var
        CommentText: Text;
}
