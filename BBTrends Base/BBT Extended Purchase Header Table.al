Table 50041 "Extended Purchase Header"
{
    Caption = 'Extended Purchase Header';
    ObsoleteState = Pending;

    fields
    {
        field(1; "Document Type"; Enum "Purchase Document Type")
        {
            Caption = 'Document Type';
            //OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            //OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; Recambio; Boolean)
        {
            Description = 'RPC-02';
        }
        field(4; Proforma; Boolean)
        {
            Description = 'RPC-02';
        }
        field(5; "ETD LC"; Date)
        {
            Description = 'RPC-02';
        }
        field(6; "Banco LC"; Text[20])
        {
            Description = 'RPC-02';
        }
        field(7; "No. LC"; Text[20])
        {
            Description = 'RPC-02';
        }
        field(8; "Fecha LC Recibida"; Date)
        {
            Description = 'RPC-02';
        }
        field(9; "Status LC"; Text[50])
        {
            Description = 'RPC-02';
        }
        field(10; "Inspección"; Text[50])
        {
            Description = 'RPC-02';
        }
        field(11; "Resultado Insp."; Option)
        {
            Description = 'RPC-02';
            OptionMembers = " ",Aceptado,Pendiente,Rechazado;
        }
        field(12; Forwarder; Text[50])
        {
            Description = 'RPC-02';
        }
        field(13; "F. Presentación ENS"; Date)
        {
            Description = 'RPC-02';
        }
        field(14; "F. Doc Originales"; Date)
        {
            Description = 'RPC-02';
        }
        field(15; "F. Despacho"; Date)
        {
            Description = 'RPC-02';
        }
        field(16; "Observ. Importación"; Text[50])
        {
            Description = 'RPC-02';
        }
        field(17; "Fecha apertura LC"; Date)
        {
            Description = 'RPC-02';
        }
    }
    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
