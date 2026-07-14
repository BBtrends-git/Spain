page 50115 "BBT Depreciation Range"
{
    ApplicationArea = All;
    Caption = 'Item Depreciation Range', Comment = 'ESP="Rango depreciación producto"';
    PageType = List;
    SourceTable = "BBT Depreciation Range";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Depreciation Days"; Rec."Depreciation Days")
                { }
                field("% Depreciation"; Rec."% Depreciation")
                { }
            }
        }
    }
}
