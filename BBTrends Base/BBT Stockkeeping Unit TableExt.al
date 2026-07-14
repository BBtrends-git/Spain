TableExtension 50160 "BBT Stockkeeping Unit" extends "Stockkeeping Unit"
{
    fields
    {
        field(50000; "Output production in location"; Code[10])
        {
            Caption = 'Output production in location';
            Description = 'RND-114';
            TableRelation = Location;
            ObsoleteState = Pending; // BBT 01/07/2025. SDA
        }
    }
}
