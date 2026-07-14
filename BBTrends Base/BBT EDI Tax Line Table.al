Table 50012 "EDI - Tax Line"
{
    Caption = 'EDI - Línea impuesto';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Tipo documento';
            OptionCaption = ' ,Pedido,Albarán,Factura';
            OptionMembers = " ","Order",Shipment,Invoice;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Nº Documento';
        }
        field(3; "Tax Line No."; Integer)
        {
            Caption = 'Nº Línea Impuesto';
        }
        field(4; "Tax Type"; Code[6])
        {
            Caption = 'Tipo Impuesto';
        }
        field(5; "Tax %"; Decimal)
        {
            Caption = '% Impuesto';
        }
        field(6; "Tax Amount"; Decimal)
        {
            Caption = 'Importe Impuesto';
        }
        field(7; "Tax Base"; Decimal)
        {
            Caption = 'Base imponible';
        }
    }
    keys
    {
        key(Key1; "Document Type", "Document No.", "Tax Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
