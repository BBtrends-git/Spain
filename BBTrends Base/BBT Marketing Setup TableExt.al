TableExtension 50153 "BBT Marketing Setup" extends "Marketing Setup"
{
    fields
    {
        field(50000; "URL Base"; Text[100])
        {
            ObsoleteState = Pending;        // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50001; "API Key"; Text[50])
        {
            ObsoleteState = Pending;        // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50002; "Empresa CRM"; Text[50])
        {
            ObsoleteState = Pending;        // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50003; "BBT CRM Item Endpoint"; Text[1024])
        {
            Caption = 'CRM Item Endpoint', comment = 'ESP="CRM Producto Endpoint"';
            ObsoleteState = Pending;        // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50004; "BBT CRM Account Endpoint"; Text[1024])
        {
            Caption = 'CRM Account Endpoint', comment = 'ESP="CRM Cuenta Endpoint"';
            ObsoleteState = Pending;        // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50005; "BBT CRM Contact Endpoint"; Text[1024])
        {
            Caption = 'CRM Contact Endpoint', comment = 'ESP="CRM Contacto Endpoint"';
            ObsoleteState = Pending;        // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50006; "BBT CRM Cust. Price Endpoint"; Text[1024])
        {
            Caption = 'CRM Customer price Endpoint', comment = 'ESP="CRM Grupo precio cliente Endpoint"';
            ObsoleteState = Pending;        // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50007; "BBT CRM Items Price Endpoint"; Text[1024])
        {
            Caption = 'CRM Items price Endpoint', comment = 'ESP="CRM Lista precios productos Endpoint"';
            ObsoleteState = Pending;        // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
    }
}
