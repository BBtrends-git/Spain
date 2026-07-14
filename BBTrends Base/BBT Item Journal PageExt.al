PageExtension 50115 "BBT Item Journal" extends "Item Journal"
{
    layout
    {
        modify("Variant Code")
        {
            Visible = false;
        }
        modify("Unit Amount")
        {
            Visible = false;
        }
        modify(Amount)
        {
            Visible = false;
        }
        modify("Discount Amount")
        {
            Visible = false;
        }
        modify("Indirect Cost %")
        {
            Visible = false;
        }
        modify("Applies-to Entry")
        {
            Visible = false;
        }
        modify("Applies-from Entry")
        {
            Visible = false;
        }
        modify("Transaction Type")
        {
            Visible = false;
        }
        modify("Transport Method")
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify("Reason Code")
        {
            Visible = false;
        }
    }
    var
        _Procesos: Codeunit "Interface SGA";

    var
        Text50000: label 'Existen líneas con almacén SGA.';
}
