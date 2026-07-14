Table 50059 "Depreciation"
{
    Caption = 'Depreciation', comment = 'ESP=""';

    fields
    {
        field(1; "Depreciation Range"; Enum "bbt depreciation range")
        {
            Caption = 'Depreciation Range', comment = 'ESP="Tramo depreciacion"';
        }
        field(2; "Depreciation Percetange"; decimal)
        {
            Caption = 'Depreciation Percetange', comment = 'ESP="Porcetanje depreciacion"';
        }
    }
    keys
    {
        key(Key1; "Depreciation Range")
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
