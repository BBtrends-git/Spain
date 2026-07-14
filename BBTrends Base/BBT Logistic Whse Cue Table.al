Table 50007 "Logistic Whse. Cue"
{
    // //09/11/18 RLG-001 Perfil usuario almacén logístico.
    Caption = 'Logistic Whse. Cue';
    ObsoleteState = Removed;    // BBT 01/07/2025

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Transfer Orders"; Integer)
        {
            CalcFormula = count("Transfer Header" where("Logistic Location" = const(true)));
            Caption = 'Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Transfer Orders - Outputs"; Integer)
        {
            CalcFormula = count("Transfer Header" where("Transfer-from Location Type" = const(Logistic)));
            Caption = 'Transfer Orders - Outputs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Transfer Orders - Inputs"; Integer)
        {
            CalcFormula = count("Transfer Header" where("Transfer-to Location Type" = const(Logistic)));
            Caption = 'Transfer Orders - Inputs';
            Editable = false;
            FieldClass = FlowField;
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
