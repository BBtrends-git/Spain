Table 50021 "Shipm. Agent Integration Entry"
{
    Caption = 'Mov. integración transportistas';

    ObsoleteState = Removed;    // BBT 01/07/2025

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Nº mov.';
        }
        field(2; Type; Option)
        {
            Caption = 'Tipo';
            OptionCaption = 'Seguimiento CBL';
            OptionMembers = "CBL Tracking";
        }
        field(3; Status; Option)
        {
            Caption = 'Estado';
            OptionCaption = 'Pendiente,Correcto,Error';
            OptionMembers = Pending,Ok,Error;
        }
        field(5; "Error Text"; Text[250])
        {
            Caption = 'Texto error';
        }
        field(10; "Import/Export Datetime"; DateTime)
        {
            Caption = 'Fecha/hora importación';
        }
        field(11; "Processing Datetime"; DateTime)
        {
            Caption = 'Fecha/hora procesamiento';
        }
        field(12; "File Blob"; Blob)
        {
        }
        field(13; "File Name"; Text[80])
        {
            Caption = 'Nombre fichero';
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()
    var
        ShipmAgentIntegrationEntry: Record "Shipm. Agent Integration Entry";
    begin
        ShipmAgentIntegrationEntry.Reset;
        if ShipmAgentIntegrationEntry.FindLast then;
        "Entry No." := ShipmAgentIntegrationEntry."Entry No." + 1;
    end;
}
