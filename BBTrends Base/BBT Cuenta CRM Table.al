Table 50046 "Cuenta CRM."
{
    ObsoleteState = Removed;    // BBT 01/07/2025

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entrada No.', comment = 'ESP="Nº mov."';
        }
        field(2; CifNif; Text[20])
        { }
        field(3; CodClienteNAV; Text[20])
        { }
        field(4; CodContactoNAV; Text[20])
        { }
        field(5; CondicionesPago; Text[50])
        { }
        field(6; ContactoPrincipalID; Text[50])
        { }
        field(7; CreditoMaximo; Decimal)
        { }
        field(8; CuentaID; Text[50])
        { }
        field(9; DescripcionCuenta; Text[150])
        { }
        field(10; DirEnvioCiudad; Text[30])
        { }
        field(11; DirEnvioCodPostal; Text[10])
        { }
        field(12; DirEnvioDireccion1; Text[100])
        { }
        field(13; DirEnvioDireccion2; Text[100])
        { }
        field(14; DirEnvioDireccion3; Text[100])
        { }
        field(15; DirEnvioEstadoOProvincia; Text[5])
        { }
        field(16; DirEnvioPais; Text[3])
        { }
        field(17; DirEnvioTelefonoContacto; Text[30])
        { }
        field(18; DirFiscalCiudad; Text[30])
        { }
        field(19; DirFiscalCodPostal; Text[10])
        { }
        field(20; DirFiscalCorreoElectronico; Text[100])
        { }
        field(21; DirFiscalDireccion1; Text[100])
        { }
        field(22; DirFiscalDireccion2; Text[100])
        { }
        field(23; DirFiscalDireccion3; Text[100])
        { }
        field(24; DirFiscalEstadoOProvincia; Text[5])
        { }
        field(25; DirFiscalTelefonoContacto; Text[30])
        { }
        field(26; DirfacturacionCiudad; Text[30])
        { }
        field(27; DirfacturacionCodPostal; Text[10])
        { }
        field(28; DirfactCorreoElectronico; Text[100])
        { }
        field(29; DirfacturacionDireccion1; Text[100])
        { }
        field(30; DirfacturacionDireccion2; Text[100])
        { }
        field(31; DirfacturacionDireccion3; Text[100])
        { }
        field(32; DirfacturacionEstadoOProvincia; Text[5])
        { }
        field(33; DirfacturacionPais; Text[3])
        { }
        field(34; DirfacturacionTelefonoContacto; Text[30])
        { }
        field(35; IdiomaCuenta; Text[15])
        { }
        field(36; IngresosAnuales; Decimal)
        { }
        field(37; ListaDePrecios; Text[100])
        { }
        field(38; NEmpresa; Text[20])
        { }
        field(39; NombreCuenta; Text[150])
        { }
        field(40; NumEmpresa; Integer)
        { }
        field(41; Telefono; Text[15])
        { }
        field(42; TerminosPago; Text[100])
        { }
        field(43; TipoDeCuenta; Text[30])
        { }
        field(45; ContactoPrincipal; Text[100])
        { }
        field(46; DirFiscalPais; Text[3])
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
    {
    }
    trigger OnInsert()
    var
        ID: Integer;
    begin
        ID := 1;
        if xRec.FindLast() then ID := xRec."Entry No." + 1;
        "Entry No." := ID;
    end;
}
