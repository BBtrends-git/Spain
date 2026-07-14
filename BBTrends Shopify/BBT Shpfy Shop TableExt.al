tableextension 73101 "BBT Shpfy Shop Ext" extends "shpfy shop"
{
    fields
    {
        field(73100; "Stock Mínimo"; Decimal)
        {
            Caption = 'Minimum Stock', Comment = 'ESP="Stock Mínimo"';
            DataClassification = ToBeClassified;
        }
        field(73104; "% Diferencia precio"; Decimal)
        {
            Caption = '% Price Difference', Comment = 'ESP="% Diferencia Precio"';
            DataClassification = ToBeClassified;
        }
        field(73105; "MarketPlace"; Boolean)
        {
            Caption = 'MarketPlace', Comment = 'ESP="MarketPlace"';
            DataClassification = ToBeClassified;
        }
        field(73106; "ID Marketplace"; Text[50])
        {
            Caption = 'ID MarketPlace', Comment = 'ESP="MarketPlace ID"';
            DataClassification = ToBeClassified;
        }
        field(73107; "Main Location"; Code[20])
        {
            //>>
            ObsoleteState = Pending;
            ObsoleteReason = 'Se usa el almacén de la tabla estandar "Shpfy Shop Location"';
            //<<
            Caption = 'Main Location', Comment = 'ESP="Almacén Principal"';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(73108; "API Key"; Text[100])
        {
            Caption = 'API Key', Comment = 'ESP="Clave API"';
        }
        field(73109; "API Password"; Text[100])
        {
            Caption = 'API Password', Comment = 'ESP="Contraseña API"';
        }
        field(73110; "API Secret"; Text[100])
        {
            Caption = 'API Secret', Comment = 'ESP="Secreto API"';
        }
        field(73111; "API Version"; Text[100])
        {
        }
        field(73112; "API Shop URL"; Text[100])
        {
            Caption = 'API Shop URL', Comment = 'ESP="URL tienda API"';
        }
        field(73113; "Customer Price Validation"; Code[20])
        {
            Caption = 'Customer Price Validation', Comment = 'ESP="Cliente Validación Precio"';
            TableRelation = Customer;
        }
    }
}
