tableextension 50010 "BBT Price List Line" extends "Price List Line"
{
    fields
    {
        field(50000; "On Promotion"; Boolean)
        {
            Caption = 'On Promotion', Comment = 'ESP="En promoción"';
            DataClassification = ToBeClassified;
        }
    }
}
