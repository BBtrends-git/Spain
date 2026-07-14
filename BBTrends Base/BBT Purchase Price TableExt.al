TableExtension 50175 "BBT Purchase Price" extends "Purchase Price"
{
    fields
    {
        field(50001; "Vendor Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No."=field("Vendor No.")));
            Caption = 'Vendor Name';
            Description = 'SDA';
            FieldClass = FlowField;
        }
        field(50002; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No."=field("Item No.")));
            Caption = 'Item Description';
            Description = 'SDA';
            FieldClass = FlowField;
        }
    }
}
