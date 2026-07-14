TableExtension 51302 "SMG Item" extends Item
{
    fields
    {
        field(51300; "SMG RAEE Amount"; Decimal)
        {
            Caption = 'RAEE Amount', Comment = 'ESP="Importe RAEE"';
            MinValue = 0;
        }
        field(51301; "SMG Royalty %"; Decimal)
        {
            Caption = 'Royalty %', Comment = 'ESP="% Royalty"';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51302; "SMG Warranty %"; Decimal)
        {
            Caption = 'Warranty %', Comment = 'ESP="% Garantia"';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51303; "SMG Standard Cost History"; Boolean)
        {
            // Obsolete
            Caption = 'Standard Cost History', Comment = 'ESP="Histórico Coste Estandar"';
        }
        field(51304; "SMG Trans Ecom Cost History"; Boolean)
        {
            // Obsolete
            Caption = 'Trans Ecom Cost History', Comment = 'ESP="Histórico Coste Transporte Ecom';
        }
    }
}