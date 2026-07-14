query 51411 "API Item Category Parent"
{
    Caption = 'API Item Category';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiitemcategoryparent';
    EntitySetName = 'apiitemcategoryparents';

    elements
    {
        dataitem(Item_Category; "Item Category")
        {
            column(Code; Code)
            { }
            column(Description; Description)
            { }
            column(Parent_Category; "Parent Category")
            { }
        }
    }
}