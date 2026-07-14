TableExtension 50121 "BBT User Setup" extends "User Setup"
{
    fields
    {
        field(50000; "Impresora por defecto"; Text[250])
        {
            TableRelation = Printer;
            ObsoleteState = Pending;        //BBT 01/07/2025
        }
        field(51164; "Exclusive Ecomm Sales Allowed"; Boolean)
        {
            Caption = 'Manage Exclusive Sales', Comment = 'ESP="Gestión Ventas Exclusivas"';
            ToolTip = 'Specifies the user with permission to manage exclusive products sales',
                        Comment = 'ESP="Especifica el usuario con permiso para gestionar ventas de productos en exclusiva"';
        }
    }
}
