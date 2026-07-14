Table 50050 "Contact CRM"
{
    Caption = 'Contacto CRM';
    ObsoleteState = Removed;    // BBT 01/07/2025

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.', comment = 'ESP="Nº mov."';
        }
        field(2; NombreContacto; Text[100])
        {
            Caption = 'Name', comment = 'ESP="Nombre"';
        }
        field(3; ApellidoContacto; Text[100])
        {
            Caption = 'Surnames', comment = 'ESP="Apellidos"';
        }
        field(4; NombrePlataforma; Text[100])
        {
            Caption = 'Platform', comment = 'ESP="Plataforma"';
        }
        field(5; ContactoID; Text[50])
        {
            Caption = 'Contact ID', comment = 'ESP="ID Contacto"';
        }
        field(6; CuentaID; Text[50])
        {
            Caption = 'Account ID', comment = 'ESP="ID Cuenta"';
        }
        field(7; CodVendedorNAV; Text[20])
        {
            Caption = 'NAV Seller Code', comment = 'ESP="Cód. Vendedor NAV"';
        }
        field(8; CodModoEnvio; Text[30])
        {
            Caption = 'Shipping Mode Code', comment = 'ESP="Cód. modo envío"';
        }
        field(9; CodContactoNAV; Text[20])
        {
            Caption = 'NAV Contact Code', comment = 'ESP="Cód. Contacto NAV"';
        }
        field(10; CuentaContactoID; Text[50])
        { }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }

    trigger OnInsert()
    var
        ID: Integer;
    begin
        ID := 1;
        if xRec.FindLast() then ID := xRec."Entry No." + 1;
        "Entry No." := ID;
    end;
}
