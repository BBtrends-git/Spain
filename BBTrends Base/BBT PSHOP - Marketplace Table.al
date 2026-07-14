Table 50034 "PSHOP - Marketplace"
{
    Caption = 'Marketplace Prestashop';

    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Código';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Nombre';
        }
        field(3; "Site Code"; Code[10])
        {
            TableRelation = "PSHOP - Site".Code;
        }
        field(10; "Salesperson Code"; Code[20])
        {
            Caption = 'Cód. vendedor';
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(11; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Venta a No. cliente';
            TableRelation = Customer."No.";
        }
        field(12; "Orders Prices VAT Included"; Boolean)
        {
            Caption = 'Precios pedidos IVA incl.';
        }
        field(13; "Dif Price Sales Price Order %"; Decimal)
        {
            Caption = '% Dif precio tarida pedido';
        }
    }
    keys
    {
        key(Key1; "Site Code", "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
