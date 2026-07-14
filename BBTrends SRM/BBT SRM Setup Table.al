table 51351 "SRM Setup"
{
    Caption = 'Vendors Relationship Setup', Comment = 'ESP="Configuración de Relaciones con Proveedor"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
        }
        field(2; "SRM Enabled"; Boolean)
        {
            Caption = 'SRM Enabled', Comment = 'ESP="SRM Activado"';
        }
        field(3; "SRM Type Enabled"; Boolean)
        {
            Caption = 'SRM Type Enabled', Comment = 'ESP="Tipo Proveedor Activado"';
        }
        field(4; "SRM Performance Enabled"; Boolean)
        {
            Caption = 'SRM Performance Enabled', Comment = 'ESP="Eficiencia Proveedor Activado"';
        }
        field(5; "SRM Classification Enabled"; Boolean)
        {
            Caption = 'SRM Classification Enabled', Comment = 'ESP="Clasificación Proveedor Activado"';
        }
        field(6; "SRM Classification Count"; Integer)
        {
            Caption = 'Classification Count', Comment = 'ESP="Clasificaciones"';
            FieldClass = FlowField;
            CalcFormula = count("SRM Vendor Classification");
            Editable = False;
        }
        field(7; "SRM Evaluators Count"; Integer)
        {
            Caption = 'Evaluators Count', Comment = 'ESP="Evaluadores"';
            FieldClass = FlowField;
            CalcFormula = count("SRM Evaluation Manager");
            Editable = False;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    { }
}