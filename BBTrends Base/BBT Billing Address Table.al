Table 50043 "Billing Address"
{
    Caption = 'Billing Address';
    LookupPageID = 50088;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.', comment = 'ESP="Nº Cliente"';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code', comment = 'ESP="Código"';
            NotBlank = true;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name', comment = 'ESP="Nombre"';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2', comment = 'ESP="Nombre 2"';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address', comment = 'ESP="Dirección"';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2', comment = 'ESP="Dirección 2"';
        }
        field(7; City; Text[30])
        {
            Caption = 'City', comment = 'ESP="Ciudad"';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(8; "Phone No."; Text[30])
        {
            Caption = 'Phone No.', comment = 'ESP="Nº teléfono"';
            ExtendedDatatype = PhoneNo;
        }
        field(9; "Telex No."; Text[30])
        {
            Caption = 'Telex No.', comment = 'ESP="Nº télex"';
        }
        field(10; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code', comment = 'ESP="Cód. país/región"';
            TableRelation = "Country/Region";
        }
        field(11; "Post Code"; Code[20])
        {
            Caption = 'Post Code', comment = 'ESP="C.P."';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code"
            else if ("Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", false);
            end;
        }
        field(12; County; Text[30])
        {
            Caption = 'County', comment = 'ESP="Provincia"';
        }
        field(13; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group', comment = 'ESP="Grupo registro IVA neg."';
            TableRelation = "VAT Business Posting Group";
        }
        field(14; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail', comment = 'ESP="Correo electrónico"';
            ExtendedDatatype = EMail;
        }
        field(15; "Entry No."; Integer)
        {
            Caption = 'Entry No.', comment = 'ESP="No. Entrada"';
        }
    }
    keys
    {
        key(Key1; "Customer No.", "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
    var
        PostCode: Record "Post Code";
}
