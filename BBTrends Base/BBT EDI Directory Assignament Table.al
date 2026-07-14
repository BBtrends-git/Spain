Table 50066 "EDI Directory Assignament"
{
    Caption = 'EDI - Directory Assignament';
    DrillDownPageID = "EDI Directory Assignament";
    LookupPageID = "EDI Directory Assignament";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Código';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Descripción';
        }
        field(51108; "DESADV Folder"; Option)
        {
            Caption = 'DESADV Folder', Comment = 'ESP="Carpeta Albaran"';
            Enabled = true;
            Editable = true;

            OptionMembers = " ","d01b","d96a";
            OptionCaption = ' ,d01b,d96a', Comment = 'ESP=" ,d01b,d96a"';
        }
        field(51109; "INVOIC Folder"; Option)
        {
            Caption = 'INVOIC Folder', Comment = 'ESP="Carpeta Factura"';
            Enabled = true;
            Editable = true;

            OptionMembers = " ","d01b","d93a","d96a";
            OptionCaption = ' ,d01b,d93a,d96a', Comment = 'ESP = " ,d01b,d93a,d96a"';
        }
    }
    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        { }
    }
}
