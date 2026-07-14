TableExtension 50152 "BBT Contact" extends Contact
{
    fields
    {
        field(50529; "Ship. Country/Region Code"; Code[10])
        {
            Caption = 'Ship. Country/Region Code';
            TableRelation = "Country/Region";
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50500; "Last CRM Update"; DateTime)
        {
            Caption = 'Last CRM Update';
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50501; "CRM ID"; Text[100])
        {
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50502; "Entry No."; Integer)
        {
            Caption = 'N. Contacto CRM';
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50503; "Customer No."; Code[20])
        {
            Caption = 'Cód. Cliente';
        }
        field(50504; "Cód. Plataforma"; Code[20])
        {
            ObsoleteState = Pending;                //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            //TableRelation = "Customer Classification".Code where(Type = const(Platform));
        }
        field(50505; "Modo Envío"; Code[20])
        {
            TableRelation = "Shipment Method";
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50506; "Invoice  Phone No."; Text[30])
        {
            Caption = 'Invoice  Phone No.';
            ExtendedDatatype = PhoneNo;
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50507; "Invoice Territory Code"; Code[10])
        {
            Caption = 'Invoice Territory Code';
            TableRelation = Territory;
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50508; "Inv. Country/Region Code"; Code[10])
        {
            Caption = 'Inv. Country/Region Code';
            TableRelation = "Country/Region";
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50509; "Inv. Post Code"; Code[20])
        {
            Caption = 'Inv. Post Code';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code"
            else if ("Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.

            trigger OnValidate()
            begin
                ValidatePostCode(Rec."Inv. City", Rec."Inv. Post Code", Rec."Inv. County", Rec."Inv. Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50510; "Inv. County"; Text[30])
        {
            Caption = 'Inv. County';
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50511; "Inv. Address"; Text[50])
        {
            Caption = 'Inv. Address';
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50512; "Inv. Address 2"; Text[50])
        {
            Caption = 'Inv. Address 2';
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50513; "Inv. City"; Text[30])
        {
            Caption = 'Inv. City';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.

            trigger OnValidate()
            begin
                ValidateCity(Rec."Inv. City", Rec."Inv. Post Code", Rec."Inv. County", Rec."Inv. Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50514; "Shipping  Phone No."; Text[30])
        {
            Caption = 'Shipping  Phone No.';
            ExtendedDatatype = PhoneNo;
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50515; "Shipping Territory Code"; Code[10])
        {
            Caption = 'Shipping Territory Code';
            TableRelation = Territory;
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50516; "Ship. Post Code"; Code[20])
        {
            Caption = 'Ship. Post Code';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code"
            else if ("Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.

            trigger OnValidate()
            begin
                ValidatePostCode(Rec."Ship. City", Rec."Ship. Post Code", Rec."Ship. County", Rec."Ship. Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50517; "Ship. County"; Text[30])
        {
            Caption = 'Ship. County';
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50518; "Ship. Address"; Text[50])
        {
            Caption = 'Ship. Address';
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50519; "Ship. Address 2"; Text[50])
        {
            Caption = 'Ship. Address 2';
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50520; "Ship. City"; Text[30])
        {
            Caption = 'Ship. City';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.

            trigger OnValidate()
            begin
                ValidateCity(Rec."Ship. City", Rec."Ship. Post Code", Rec."Ship. County", Rec."Ship. Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50521; "Max Credit"; Decimal)
        {
            Caption = 'Max. Credit';
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50522; "Payment Terms Code"; Code[20])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50523; "Payment Method Code"; Code[20])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.

            trigger OnValidate()
            var
                PaymentMethod: Record "Payment Method";
            begin
            end;
        }
        field(50524; "Sales Price List"; Code[10])
        {
            Caption = 'Sales Price List';
            //TableRelation = "Customer Price Group";
            ObsoleteState = Pending;                //>> BBT. 16/03/2026. Implantación de la extensión SMG.
        }
        field(50525; "Customer Type"; Option)
        {
            ObsoleteState = Pending;                //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            Caption = 'Customer Type';
            OptionCaption = ' ,Tradicional,Gran Distribución,Portugal,Export,Amazon,Marketplace,E-commerce,Online,Lifevit';
            OptionMembers = " ",Tradicional,"Gran Distribución",Portugal,Export,Amazon,Marketplace,"E-commerce",Online,Lifevit;
        }
        field(50526; "Inv. E-mail"; Text[150])
        {
            Caption = 'E-mail facturación';
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50527; "Ship. E-mail"; Text[150])
        {
            Caption = 'E-mail dir. envío';
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50528; "Ingresos Anuales"; Decimal)
        {
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
    }
    procedure ValidateCity(var CityTxt: Text[30]; var PostCode: Code[20]; var CountyTxt: Text[30]; var CountryCode: Code[10]; UseDialog: Boolean)
    var
        PostCodeRec: Record "Post Code";
        PostCodeRec2: Record "Post Code";
        SearchCity: Code[30];
        IsHandled: Boolean;
    begin
        if not GuiAllowed then exit;
        IsHandled := false;
        if IsHandled then exit;
        if CityTxt <> '' then begin
            SearchCity := CityTxt;
            PostCodeRec.SetCurrentKey("Search City");
            if StrPos(SearchCity, '*') = StrLen(SearchCity) then
                PostCodeRec.SetFilter("Search City", SearchCity)
            else
                PostCodeRec.SetRange("Search City", SearchCity);
            if not PostCodeRec.FindFirst then exit;
            if CountryCode <> '' then begin
                PostCodeRec.SetRange("Country/Region Code", CountryCode);
                if not PostCodeRec.FindFirst then PostCodeRec.SetRange("Country/Region Code");
            end;
            PostCodeRec2.Copy(PostCodeRec);
            if UseDialog and (PostCodeRec2.Next = 1) then if PAGE.RunModal(PAGE::"Post Codes", PostCodeRec, PostCodeRec.Code) <> ACTION::LookupOK then Error('');
            PostCode := PostCodeRec.Code;
            CityTxt := PostCodeRec.City;
            CountryCode := PostCodeRec."Country/Region Code";
            CountyTxt := PostCodeRec.County;
        end;
    end;

    procedure ValidatePostCode(var CityTxt: Text[30]; var PostCode: Code[20]; var CountyTxt: Text[30]; var CountryCode: Code[10]; UseDialog: Boolean)
    var
        PostCodeRec: Record "Post Code";
        PostCodeRec2: Record "Post Code";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then exit;
        if PostCode <> '' then begin
            if StrPos(PostCode, '*') = StrLen(PostCode) then
                PostCodeRec.SetFilter(Code, PostCode)
            else
                PostCodeRec.SetRange(Code, PostCode);
            if not PostCodeRec.FindFirst then exit;
            if CountryCode <> '' then begin
                PostCodeRec.SetRange("Country/Region Code", CountryCode);
                if not PostCodeRec.FindFirst then PostCodeRec.SetRange("Country/Region Code");
            end;
            PostCodeRec2.Copy(PostCodeRec);
            if UseDialog and (PostCodeRec2.Next = 1) and GuiAllowed then if PAGE.RunModal(PAGE::"Post Codes", PostCodeRec, PostCodeRec.Code) <> ACTION::LookupOK then exit;
            PostCode := PostCodeRec.Code;
            CityTxt := PostCodeRec.City;
            CountryCode := PostCodeRec."Country/Region Code";
            CountyTxt := PostCodeRec.County;
        end;
    end;
}
