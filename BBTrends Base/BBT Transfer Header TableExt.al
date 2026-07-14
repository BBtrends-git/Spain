TableExtension 50162 "BBT Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(50000; "Production Order No."; Code[20])
        {
            TableRelation = "Production Order"."No.";
        }
        field(50001; "Status SGA"; Option)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            OptionMembers = " ","Enviado SGA","Bloqueado SGA";
            Description = 'SGA';
            Editable = false;
            OptionCaption = ' ,SGA Sent,SGA Locked', Comment = 'ESP=" ,Enviado SGA,Bloqueado SGA"';
        }
        field(50002; "Grabado SGA"; DateTime)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
            Editable = false;
        }
        field(50003; "Leido SGA"; DateTime)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
            Editable = false;
        }
        field(50004; "ModificadoSGA"; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
            Editable = false;
        }
        field(50005; "Transfer-from Location Type"; Option)
        {
            Caption = 'Logistic Location Code';
            Description = 'RLG-001';
            OptionCaption = ' ,Logistic,Raw Materials,Factory';
            OptionMembers = ,Logistic,"Raw Materials",Factory;
        }
        field(50006; "Transfer-to Location Type"; Option)
        {
            Caption = 'Transfer. a-tipo almacén';
            Description = 'RLG-001';
            OptionCaption = ' ,Logistic,Raw Materials,Factory';
            OptionMembers = ,Logistic,"Raw Materials",Factory;
        }
        field(50007; "Logistic Location"; Boolean)
        {
            Caption = 'Logistic Location';
            Description = 'RLG-001';
        }
        field(50059; "Customer Service No."; Code[20])
        {
            Caption = 'No. servicio cliente';
            Editable = false;
            TableRelation = "Customer Service Header"."No.";
        }
    }
    procedure SetLogisticLocation(FromLocation: Code[10]; ToLocation: Code[10]): Boolean
    var
        InvSetup: Record "Inventory Setup";
    begin
        //-RLG-001
        InvSetup.Get;
        InvSetup.TestField("Logistic Location Code");
        if (FromLocation = InvSetup."Logistic Location Code") or (ToLocation = InvSetup."Logistic Location Code") then exit(true);
        exit(false);
        //+RLG-001
    end;

    procedure GetLocationType(LocationCode: Code[10]): Integer
    var
        InvSetup: Record "Inventory Setup";
    begin
        //-RLG-001
        InvSetup.GET;
        InvSetup.TESTFIELD("Logistic Location Code");
        InvSetup.TESTFIELD("Raw Materials Location Code");
        InvSetup.TESTFIELD("Factory Location Code");
        CASE TRUE OF
            LocationCode = InvSetup."Logistic Location Code":
                EXIT(1);
            LocationCode = InvSetup."Raw Materials Location Code":
                EXIT(2);
            LocationCode = InvSetup."Factory Location Code":
                EXIT(3);
        END;
        EXIT(0);
        //+RLG-001
    end;
}
