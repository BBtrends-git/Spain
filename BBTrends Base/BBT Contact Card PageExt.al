PageExtension 50176 "BBT Contact Card" extends "Contact Card"
{
    layout
    {
        modify(Name)
        {
            ShowMandatory = true;
        }
        modify(Address)
        {
            ShowMandatory = true;
        }
        modify("Post Code")
        {
            ShowMandatory = true;
        }
        modify(City)
        {
            ShowMandatory = true;
        }
        modify(County)
        {
            ShowMandatory = true;
        }
        modify("Country/Region Code")
        {
            ShowMandatory = true;
        }
        addafter("Next Task Date")
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            //>>  BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
            /*
            field("CRM ID"; Rec."CRM ID")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Modo Envío"; Rec."Modo Envío")
            {
                ApplicationArea = Basic;
            }
            field("Cód. Plataforma"; Rec."Cód. Plataforma")
            {
                ApplicationArea = Basic;
            }
            field("Payment Terms Code"; Rec."Payment Terms Code")
            {
                ApplicationArea = Basic;
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = Basic;
            }
            field("Max Credit"; Rec."Max Credit")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Ingresos Anuales"; Rec."Ingresos Anuales")
            {
                ApplicationArea = Basic;
            }
            field("Sales Price List"; Rec."Sales Price List")
            {
                ApplicationArea = Basic;
            }
            */
            //<<
            //>> BBT. SMG Extension. 
            /*
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = Basic;
            }
            */
            //<<
        }
    }
    /*
    var
        FaltaRegion: label 'Country/region is missing';
        FaltaCIF: label 'Vat registration number is missing';
        FaltanDatos: label 'Missing data to enter: Address, Zip Code, Town, Province, Country and CIF/NIF are required';
    */
}
