TableExtension 50139 "BBT Payment Method" extends "Payment Method"
{
    fields
    {
        field(50000; "EDI - Payment Method"; Option)
        {
            Caption = 'EDI - Forma de pago';
            Description = 'EDI';
            OptionCaption = ' ,Pago a cuenta bancaria,Pago mediante giro bancario,En efectivo,Cheque,Pagaré';
            OptionMembers = " ","42","14E","10","20","60";
        }
        field(50001; "Credit Letter"; Boolean)
        {
            ObsoleteState = Pending;
            Caption = 'Credit Letter';
            Description = 'RPC-01';
        }
        field(50002; "Description CRM"; Text[50])
        {
            ObsoleteState = Pending;
            Caption = 'Description CRM';
        }
    }
}
