PageExtension 50105 "BBT Countries/Regions" extends "Countries/Regions"
{
    layout
    {
        addafter(Name)
        {
            field("Export Name"; Rec."Export Name")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("VAT Scheme")
        {
            field("Country Origin on Sales Docs"; Rec."Country Origin on Sales Docs")
            {
                ApplicationArea = Basic;
            }
            field("Tariff Code on Sales Docs"; Rec."Tariff Code on Sales Docs")
            {
                ApplicationArea = Basic;
            }
            field("Scrap Information"; Rec."Scrap Information")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
