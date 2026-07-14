tableextension 50004 "BBT Return Receipt Line" extends "Return Receipt Line"
{
    fields
    {
        field(50061; "BBT Shipping Charge"; Boolean)
        {
            Caption = 'Shipping Charge', comment = 'ESP="Cargo portes"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
}
