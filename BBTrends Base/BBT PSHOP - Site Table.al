Table 50023 "PSHOP - Site"
{
    ObsoleteState = Removed;        // BBT 01/07/2025

    Caption = 'Sitio Prestashop';

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Código';
        }
        field(2; "API Key"; Text[80])
        {
            Caption = 'Clave API';
        }
        field(3; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Venta a n. cliente';
            TableRelation = Customer;

            trigger OnValidate()
            var
                ContactBusinessRelation: Record "Contact Business Relation";
                Customer: Record Customer;
                CreateContsfromCustomers: Report "Create Conts. from Customers";
            begin
                if "Sell-to Customer No." <> '' then begin
                    if not CheckContactExistsForCustomer("Sell-to Customer No.") then begin
                        if not Confirm('No se ha detectado contacto relacionado al cliente seleccionado. Desea crear el contacto ahora? Este requerimiento es obligatorio') then Error('');
                        Customer.Reset;
                        Customer.SetRange("No.", "Sell-to Customer No.");
                        Clear(CreateContsfromCustomers);
                        CreateContsfromCustomers.SetTableview(Customer);
                        CreateContsfromCustomers.RunModal;
                        if not CheckContactExistsForCustomer("Sell-to Customer No.") then Error('No se ha detectado la existencia del contacto. Se abortará este proceso');
                    end;
                end;
            end;
        }
        field(4; "Salesperson Code"; Code[20])
        {
            Caption = 'Cód. vendedor';
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(5; "Orders Prices VAT Included"; Boolean)
        {
            Caption = 'Precios pedidos IVA incl.';
        }
        field(6; "Customer Price Group"; Code[20])
        {
            Caption = 'Grupo precio cliente';
            TableRelation = "Customer Price Group".Code;
        }
        field(7; "Ship-to Address Nos."; Code[20])
        {
            Caption = 'No. serie cód. dirección cliente';
            TableRelation = "No. Series".Code;
        }
        field(8; "Simplified Posted Invoice Nos."; Code[20])
        {
            Caption = 'No. facturas simplificadas reg.';
            TableRelation = "No. Series".Code;
        }
        field(9; "Connection Option"; Option)
        {
            Caption = 'Opción conexión';
            OptionMembers = NAV,DLL;
        }
        field(10; "Website Root URL"; Text[80])
        {
            Caption = 'Raíz sitio web';
        }
        field(11; "Orders URI"; Text[50])
        {
            Caption = 'URI pedidos';

            trigger OnValidate()
            begin
                ValidateURI("Orders URI");
            end;
        }
        field(12; "Customer Threads URI"; Text[50])
        {
            Caption = 'URI hilos clientes';
        }
        field(13; "Customer Messages URI"; Text[50])
        {
            Caption = 'URI mensajes clientes';
        }
        field(14; "Products URI"; Text[50])
        {
            Caption = 'URI productos';
        }
        field(15; "Customers URI"; Text[50])
        {
            Caption = 'URI clientes';
        }
        field(16; "Addresses URI"; Text[50])
        {
            Caption = 'URI direcciones';
        }
        field(17; "Stock Available URI"; Text[50])
        {
            Caption = 'URI stock disponible';
        }
        field(18; "Categories URI"; Text[50])
        {
            Caption = 'URI categorías';
        }
        field(19; "Countries URI"; Text[50])
        {
            Caption = 'URI países';
        }
        field(20; "Order States URI"; Text[50])
        {
            Caption = 'URI estados pedidos';
        }
        field(21; "Order Histories URI"; Text[50])
        {
            Caption = 'URI historial pedidos';
        }
        field(22; "Order Carrier URI"; Text[50])
        {
            Caption = 'URI transporte pedido';
        }
        field(23; "Order Carrier - Send email"; Boolean)
        {
            Caption = 'Enviar correo-e al actualizar tracking';
        }
        field(24; Active; Boolean)
        { }
        field(25; "Order Count"; Integer)
        {
            CalcFormula = count("PSHOP - Order Header" where("Site Code" = field(Code)));
            Caption = 'No. pedidos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Shops URI"; Text[50])
        {
            Caption = 'URI tiendas';
        }
    }
    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }

    local procedure ValidateURI(var URIText: Text)
    begin
        if URIText = '' then exit;
        if CopyStr(URIText, 1, 1) <> '/' then URIText := '/' + URIText;
        if CopyStr(URIText, StrLen(URIText)) = '/' then URIText := CopyStr(URIText, 1, StrLen(URIText) - 1);
    end;

    local procedure CheckContactExistsForCustomer(CustomerNo: Code[20]): Boolean
    var
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        ContactBusinessRelation.Reset;
        ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."link to table"::Customer);
        ContactBusinessRelation.SetRange("No.", CustomerNo);
        exit(ContactBusinessRelation.FindSet);
    end;
}
