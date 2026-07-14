TableExtension 50112 "BBT Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(50000; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Description = '01/07/19 TC-001';
            TableRelation = User."User Name";

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
            end;
        }
        field(50001; "Hora Registro"; DateTime)
        {
            Description = '01/07/19 TC-001';
        }
        field(50002; "Work Shift Code"; Code[10])
        {
            Caption = 'Work Shift Code';
            Description = '01/07/19 TC-001';
            TableRelation = "Work Shift";
        }
    }
    var
        rLot: Record "Lot No. Information";
}
