TableExtension 50118 "BBT Company Information" extends "Company Information"
{
    fields
    {
        field(50000; "Commercial Register Text"; Text[150])
        {
            Caption = 'Commercial Register Text';
            Description = '001';
        }
        field(50001; "Cost Recicling Text"; Text[150])
        {
            Caption = 'Cost Recicling Text';
            Description = '001';
        }
        field(50002; SGA; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
        }
        field(50003; "Texto pie  protecc. de datos 1"; Text[250])
        { }
        field(50004; "Texto pie  protecc. de datos 2"; Text[250])
        { }
        field(50005; "Texto pie  protecc. de datos 3"; Text[250])
        { }
        field(50006; "Texto pie  protecc. de datos 4"; Text[250])
        { }
        field(50007; "Texto pie  protecc. de datos 5"; Text[250])
        { }
        field(50008; "EDI ID"; Text[35])
        {
            Caption = 'Id. EDI';
            Description = 'EDI';
        }
        field(50009; Text_ISO_ESP; Text[150])
        {
            Description = 'INC-2020-10-120886';
        }
        field(50010; Text_ISO_ENG; Text[150])
        {
            Description = 'INC-2020-10-120886';
        }
        field(50011; "Comentarios POP-UP"; Boolean)
        {
            ObsoleteState = Removed;        //BBT 01/07/2025
        }
        field(51106; "EDI ID PL"; text[35])
        {
            Caption = 'Poland EDI ID', Comment = 'ESP="EDI ID Polonia"';
            Enabled = true;
            Editable = true;
        }
    }
}
