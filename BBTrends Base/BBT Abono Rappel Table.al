Table 50058 "Abono Rappel"
{
    ObsoleteState = Removed;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.', comment = 'ESP="Nº mov."';
        }
        field(2; "Line No."; integer)
        {
            Caption = 'Line No.', comment = 'ESP="No. Linea"';
        }
        field(3; "Customer No."; Code[20])
        {
            Editable = true;
            TableRelation = Customer."No.";
        }
        field(4; "Description"; text[500])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(5; "Customer Group"; code[50])
        {
            Caption = 'Customer Group', comment = 'ESP="Grupo Cliente"';
        }
        field(6; Brand; text[50])
        {
            Caption = 'Brand', comment = 'ESP="Marca"';
        }
        field(7; Periodicity; Enum "BBT Periodicity")
        {
            Caption = 'Periodicity', comment = 'ESP="Periodicidad"';
        }
        field(8; "% Apos"; decimal)
        {
            Caption = '% Apos', comment = 'ESP="% Apos"';
        }
        field(9; "Acum Amount"; decimal)
        {
            Caption = 'Acum Amount', comment = 'ESP="Importe Acumulado"';
        }
        field(10; "Estimated Rappel Amt"; decimal)
        {
            Caption = 'Estimated Rappel Amt', comment = 'ESP="Estimated Rappel Amt"';
        }
        field(11; "Total Amount"; decimal)
        {
            Caption = 'Total Amount', comment = 'ESP="Importe Total"';
        }
    }
    keys
    {
        key(Key1; "Customer No.")
        { }
    }
    fieldgroups
    { }

    trigger OnInsert()
    var
        myInt: Integer;
        Customer: Record Customer;
    begin
        //Clear(Customer);
        //Customer.
    end;
}
