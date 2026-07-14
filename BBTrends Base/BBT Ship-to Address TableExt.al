TableExtension 50135 "BBT Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        field(50000; "EDI ID"; Text[35])
        {
            Caption = 'Id. EDI';
            Description = 'EDI';
        }
        field(50001; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
    }
}
