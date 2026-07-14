Table 51104 "BBT-IT SGA Blocked Documents"
{
    //>> BBT SGA Extension
    ObsoleteState = Pending;
    //<<

    fields
    {
        field(51170; "Document Type"; Option)
        {
            OptionCaption = 'Sales,Purchase,Transfer,Sales Return,Purchase Return',
                    Comment = 'ESP="Ventas,Compras,Transferencia,Devolución Ventas,Devolución Compras"';
            OptionMembers = "Sales","Purchase","Transfer","Sales Return","Purchase Return";
        }
        field(51171; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="No. Documento"';
        }
    }
    keys
    {
        key(Key1; "Document Type", "Document No.")
        {
            Clustered = true;
        }
    }
}