TableExtension 50169 "BBT Service Zone" extends "Service Zone"
{
    fields
    {
        field(50000; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            Description = '001';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                ApprovalEntry: Record "Approval Entry";
            begin
            end;
        }
    }
}
