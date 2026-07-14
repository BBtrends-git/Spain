Page 50077 "EDI Conceptos abonos"
{
    PageType = List;
    SourceTable = "Abonos EDI";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ERE1L Descripcion1Articulo"; Rec."ERE1L Descripcion1Articulo")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    { }
}
