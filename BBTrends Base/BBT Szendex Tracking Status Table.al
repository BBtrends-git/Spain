Table 50016 "Szendex Tracking Status"
{
    fields
    {
        field(1; Status; Code[50])
        {
            Caption = 'Estado';
        }
        field(10; "Reason Code"; Code[20])
        {
            Caption = 'Cód. auditoría';
            TableRelation = "Reason Code".Code;
        }
        field(11; "Shipment Delivered"; Boolean)
        {
            Caption = 'Envío entregado';
        }
        field(12; Type; Option)
        {
            OptionCaption = 'Szendex,CBL';
            OptionMembers = Szendex, CBL;
        }
        field(13; "Shipment Finished"; Boolean)
        {
            Caption = 'Expedición terminada';
        }
    }
    keys
    {
        key(Key1; Status, Type)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
}
