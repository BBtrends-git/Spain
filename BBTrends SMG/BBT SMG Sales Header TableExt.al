TableExtension 51303 "SMG Sales Header" extends "Sales Header"
{
    fields
    {
        field(51300; "SMG Blocked for Short Margin"; Boolean)
        {
            Caption = 'Blocked for Short Margin', Comment = 'ESP="Margen Insuficiente"';
            Editable = false;
        }
        field(51301; "SMG Total Margin %"; Decimal)
        {
            Caption = 'Total Margin %', Comment = 'ESP="% Margen Total"';
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
    }
}