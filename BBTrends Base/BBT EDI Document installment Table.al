Table 50014 "EDI - Document installment"
{
    Caption = 'EDI - Vencimiento documento';

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
            Caption = 'Nº documento';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Nº línea';
        }
        field(4; "Payment time ref. type"; Option)
        {
            Caption = 'Tipo ref. Tiempo pago';
            OptionCaption = ' ,5 Fecha factura,29 (sin documentación),66 Fecha especificada,69 Fecha envío factura,81 Fecha envío';
            OptionMembers = " ","5","29","66","69","81";
        }
        field(5; "Time relation type"; Option)
        {
            Caption = 'Tipo relación de tiempo';
            OptionCaption = ' ,1 Fecha referencia,3 Después de referencia';
            OptionMembers = " ","1","3";
        }
        field(6; "Period type"; Option)
        {
            Caption = 'Tipo período';
            OptionCaption = ' ,D Día,M Mes,WD Días laborable,Y Año';
            OptionMembers = " ",D,M,WD,Y;
        }
        field(7; "Period number"; Decimal)
        {
            Caption = 'Nº Períodos';
        }
        field(8; "Due date"; Date)
        {
            Caption = 'Fecha vto.';
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Importe vto.';
        }
    }
    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
