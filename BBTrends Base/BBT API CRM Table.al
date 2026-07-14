Table 50049 "API CRM"
{
    ObsoleteState = Removed;

    fields
    {
        field(1; "Entry No."; Integer)
        { }
        field(2; id; Code[30])
        { }
        field(3; Peticion; Blob)
        { }
        field(4; Respuesta; Blob)
        { }
        field(5; Fecha; DateTime)
        { }
        field(6; Tipo; Text[30])
        { }
        field(7; Usuario; Code[30])
        { }
        field(8; url; Text[250])
        { }
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
        num: Integer;
        rAPICRM: Record "API CRM";
    begin
        num := 1;
        if rAPICRM.FindLast() then num := rAPICRM."Entry No." + 1;
        Clear(rAPICRM);
        "Entry No." := num;
        Fecha := CurrentDatetime;
        Usuario := UserId;
    end;

    procedure WritePeticionAsText(Content: Text; Encoding: TextEncoding)
    var
        OutStr: OutStream;
    begin
        Clear(Peticion);
        if Content = '' then exit;
        Peticion.CreateOutstream(OutStr, Encoding);
        OutStr.WriteText(Content);
    end;

    procedure ReadPeticionAsText(LineSeparator: Text; Encoding: TextEncoding) Content: Text
    var
        InStream: InStream;
        ContentLine: Text;
    begin
        Peticion.CreateInstream(InStream, Encoding);
        InStream.ReadText(Content);
        while not InStream.eos do begin
            InStream.ReadText(ContentLine);
            Content += LineSeparator + ContentLine;
        end;
    end;

    procedure WriteRespuestaAsText(Content: Text; Encoding: TextEncoding)
    var
        OutStr: OutStream;
    begin
        Clear(Respuesta);
        if Content = '' then exit;
        Respuesta.CreateOutstream(OutStr, Encoding);
        OutStr.WriteText(Content);
    end;

    procedure ReadRespuestaAsText(LineSeparator: Text; Encoding: TextEncoding) Content: Text
    var
        InStream: InStream;
        ContentLine: Text;
    begin
        Respuesta.CreateInstream(InStream, Encoding);
        InStream.ReadText(Content);
        while not InStream.eos do begin
            InStream.ReadText(ContentLine);
            Content += LineSeparator + ContentLine;
        end;
    end;
}
