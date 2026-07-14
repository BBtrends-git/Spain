query 51405 "API Customer"
{
    Caption = 'API Customer';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apicustomer';
    EntitySetName = 'apicustomers';

    elements
    {
        dataitem(Customer; Customer)
        {
            column(No; "No.")
            { }
            column(Name; "Name")
            { }
            column(Name_2; "Name 2")
            { }
            column(Address; "Address")
            { }
            column(Address_2; "Address 2")
            { }
            column(Post_Code; "Post Code")
            { }
            column(City; "City")
            { }
            column(County; "County")
            { }
            column(Country_Region_Code; "Country/Region Code")
            { }
            column(Phone_No; "Phone No.")
            { }
            column(Fax_No; "Fax No.")
            { }
            column(E_Mail; "E-Mail")
            { }
            column(Home_Page; "Home Page")
            { }
            column(VAT_Registration_No; "VAT Registration No.")
            { }
            column(Salesperson_Code; "Salesperson Code")
            { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(Credit_Limit_LCY; "Credit Limit (LCY)")
            { }
            column(Gen_Bus_Posting_Group; "Gen. Bus. Posting Group")
            { }
            column(Customer_Posting_Group; "Customer Posting Group")
            { }
            column(VAT_Bus_Posting_Group; "VAT Bus. Posting Group")
            { }
            column(Currency_Code; "Currency Code")
            { }
            column(Language_Code; "Language Code")
            { }
            column(Customer_Price_Group; "Customer Price Group")
            { }
            column(Customer_Disc_Group; "Customer Disc. Group")
            { }
            column(Statistics_Group; "Statistics Group")
            { }
            column(Payment_Method_Code; "Payment Method Code")
            { }
            column(Payment_Terms_Code; "Payment Terms Code")
            { }
            column(Shipping_Agent_Code; "Shipping Agent Code")
            { }
            column(Shipping_Agent_Service_Code; "Shipping Agent Service Code")
            { }
            column(Service_Zone_Code; "Service Zone Code")
            { }
            //>>>> BBT - SMG
            //>> Obsolete
            column(CustomerType; "Customer Type")
            { }
            column(DEVSFIN; "DEVS  FIN %")
            { }
            column(Comission; "Comission %")
            { }
            column(Transporteventas; "Transporte ventas %")
            { }
            column(CondicionesfuerafactCOLS; "Condiciones fuera fact. % COLS")
            { }
            column(Platform; "Platform")
            { }
            column(National_Group; "National Group")
            { }
            column(Purchase_Group; "Purchase Group")
            { }
            column(No_Apply_RAEE; "No Apply RAEE")
            { }
            column(Condiciones_FF_APOs_2024; "Condiciones F.F. % APOs 2024")
            { }
            column(Condiciones_FF_COLs_2024; "Condiciones F.F. % COLs 2024")
            { }
            column(Condiciones_F_F_APOs_2025; "Condiciones F.F. % APOs 2025")
            { }
            column(Condiciones_F_F_COLs_2025; "Condiciones F.F. % COLs 2025")
            { }
            //<< Obsolete
            column(SMG_Purchase_Group; "SMG Purchase Group")
            { }
            column(SMG_Customer_Type; "SMG Customer Type")
            { }
            column(SMG_National_Group; "SMG National Group")
            { }
            column(SMG_Platform; "SMG Platform")
            { }
            column(SMG_No_Apply_RAEE; "SMG No Apply RAEE")
            { }
            column(SMG_Devs_Fin_TP; "SMG Devs Fin %")
            { }
            column(SMG_Transport_Sales_TP; "SMG Transport Sales %")
            { }
            column(SMG_Commission_TP; "SMG Commission %")
            { }
            //<<<< BBT - SMG
        }
    }
}