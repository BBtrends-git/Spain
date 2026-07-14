table 50051 "BBT Warranty Types"
{
    Caption = 'Warranty Types', comment = 'ESP="Tipo Garantías"';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Code"; Code[10])
        //Indica el Código del tipo de Garantía.
        {
            DataClassification = ToBeClassified;
            Caption = 'Code', comment = 'ESP="Código"';
        }
        field(20; "Description"; Text[100])
        //Indica la descripción de la Garantía
        {
            DataClassification = ToBeClassified;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(30; "Duration"; DateFormula)
        //Indica la duración en años de la Garantía
        {
            DataClassification = ToBeClassified;
            Caption = 'Duration (Formula)', comment = 'ESP="Duración (Fórmula)"';
        }
        field(40; "Total Items"; Integer)
        //Este es un campo calculado (flowfield) utilizado para calcular automáticamente el número de productos asociados con la categoría seleccionada.
        {
            FieldClass = FlowField;
            CalcFormula = count("BBT Warranty Entry" where("Warranty Type"=field(Code)));
            Caption = 'Total Items', comment = 'ESP="Productos totales"';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(K2; Description)
        //Esta clave secundaria se define con la Unique establecida en true y esto garantiza que no puede tener registros en esta tabla con el mismo valor que este campo:
        {
            Unique = true;
        }
    }
}
