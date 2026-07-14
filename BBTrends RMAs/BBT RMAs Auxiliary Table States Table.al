table 51203 "RMAS Auxiliary Table States"
{
    Caption = 'Sales Return Reason', Comment = 'ESP="Motivos Devolucion Ventas"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Auxiliary Type"; Enum "RMAs Auxiliary Table States")
        {
            Caption = 'Auxiliary Type', Comment = 'ESP="Tipo Auxiliar"';
        }
        field(2; "Auxiliary Name"; Text[50])
        {
            Caption = 'Auxiliary Name', Comment = 'ESP="Nombre Auxiliar"';
        }
    }
    keys
    {
        key(Key1; "Auxiliary Type", "Auxiliary Name")
        {
            Clustered = true;
        }
    }
}