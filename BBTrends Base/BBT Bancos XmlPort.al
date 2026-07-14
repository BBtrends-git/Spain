XmlPort 50015 "Bancos"
{
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Bank Account"; "Bank Account")
            {
                XmlName = 'Banco';

                fieldelement(No; "Bank Account"."No.")
                {
                    trigger OnAfterAssignField()
                    begin
                        Descuento := '';
                        Cobro := '';
                    end;
                }
                fieldelement(Nombre; "Bank Account".Name)
                { }
                textelement(Oficina)
                { }
                fieldelement(Direccion; "Bank Account".Address)
                { }
                fieldelement(CP; "Bank Account"."Post Code")
                { }
                fieldelement(Ciudad; "Bank Account".City)
                { }
                fieldelement(Telefono; "Bank Account"."Phone No.")
                { }
                fieldelement(Iban; "Bank Account".Iban)
                { }
                fieldelement(Swift; "Bank Account"."SWIFT Code")
                { }
                fieldelement(EmisorSEPA; "Bank Account"."Creditor No.")
                { }
                textelement(Descuento)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        if Descuento <> '' then begin
                            Sufijos.Init;
                            Sufijos."Bank Acc. Code" := "Bank Account"."No.";
                            Sufijos.Suffix := Descuento;
                            Sufijos.Insert;
                        end;
                    end;
                }
                textelement(Cobro)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        if Cobro <> '' then begin
                            Sufijos.Init;
                            Sufijos."Bank Acc. Code" := "Bank Account"."No.";
                            Sufijos.Suffix := Cobro;
                            Sufijos.Insert;
                        end;
                    end;
                }
            }
        }
    }
    requestpage
    {
        layout
        { }
        actions
        { }
    }
    var
        Sufijos: Record Suffix;
}
