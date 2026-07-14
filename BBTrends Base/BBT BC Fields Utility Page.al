Page 50023 "BC Fields Utility"
{
    PageType = List;
    SourceTable = "Field";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TableNo; Rec.TableNo)
                {
                    ApplicationArea = Basic;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(TableName; Rec.TableName)
                {
                    ApplicationArea = Basic;
                }
                field(FieldName; Rec.FieldName)
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(Len; Rec.Len)
                {
                    ApplicationArea = Basic;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic;
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = Basic;
                }
                field("Type Name"; Rec."Type Name")
                {
                    ApplicationArea = Basic;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = Basic;
                }
                field(RelationTableNo; Rec.RelationTableNo)
                {
                    ApplicationArea = Basic;
                }
                field(RelationFieldNo; Rec.RelationFieldNo)
                {
                    ApplicationArea = Basic;
                }
                field(SQLDataType; Rec.SQLDataType)
                {
                    ApplicationArea = Basic;
                }
                field(OptionString; Rec.OptionString)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    { }
}
