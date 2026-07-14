XmlPort 50016 "Transportistas"
{
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Shipping Agent";
            "Shipping Agent")
            {
                XmlName = 'Transportista';

                textelement(Codigo)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        "Shipping Agent".Code := CopyStr(Codigo, 1, 10);
                    end;
                }
                fieldelement(Nombre;
                "Shipping Agent".Name)
                { }
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
}
