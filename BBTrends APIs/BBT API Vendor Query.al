query 51407 "API Vendor"
{
    Caption = 'API Vendor';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apivendor';
    EntitySetName = 'apivendors';

    elements
    {
        dataitem(Vendor; Vendor)
        {
            column(No; "No.")
            { }
            column(Name; Name)
            { }
            column(Name_2; "Name 2")
            { }
            column(Address; Address)
            { }
            column(Address_2; "Address 2")
            { }
            column(Post_Code; "Post Code")
            { }
            column(City; City)
            { }
            column(County; County)
            { }
            column(Phone_No; "Phone No.")
            { }
            column(Fax_No; "Fax No.")
            { }
            column(E_Mail; "E-Mail")
            { }
            column(VAT_Registration_No; "VAT Registration No.")
            { }
            column(Home_Page; "Home Page")
            { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(Currency_Code; "Currency Code")
            { }
            column(Language_Code; "Language Code")
            { }
            column(Statistics_Group; "Statistics Group")
            { }
            column(Payment_Method_Code; "Payment Method Code")
            { }
            column(Payment_Terms_Code; "Payment Terms Code")
            { }
            column(Shipment_Method_Code; "Shipment Method Code")
            { }
            column(Vendor_Posting_Group; "Vendor Posting Group")
            { }
            column(Gen_Bus_Posting_Group; "Gen. Bus. Posting Group")
            { }
            column(VAT_Bus_Posting_Group; "VAT Bus. Posting Group")
            { }
            column(RelatedCustomer; "Telex Answer Back")
            { }
        }
    }
}
