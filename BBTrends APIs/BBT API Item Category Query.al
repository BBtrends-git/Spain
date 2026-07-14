query 51400 "API Item Category"
{
    Caption = 'API Item Category';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiitemcategory';
    EntitySetName = 'apiitemcategorys';

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