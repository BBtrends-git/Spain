TableExtension 51453 "SGA Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(51450; "SGA Status"; Enum "SGA Status")
        {
            Caption = 'SGA Status', Comment = 'ESP="Estado SGA"';
            Editable = false;
        }
        field(51451; "SGA Inserted"; DateTime)
        {
            Caption = 'SGA Inserted', Comment = 'ESP="Grabado SGA"';
            Editable = false;
        }
        field(51452; "SGA Readed"; DateTime)
        {
            Caption = 'SGA Readed', Comment = 'ESP="Leido SGA"';
            Editable = false;
        }
        field(51453; "SGA Modified"; Boolean)
        {
            Caption = 'SGA Modified', Comment = 'ESP="Modificado SGA"';
            Editable = false;
        }
    }
}