Codeunit 50010 "BBT Json Text Reader/Writer"
{
    trigger OnRun()
    begin
    end;

    var //StringBuilder: dotnet StringBuilder0;
        TextBuilder: TextBuilder;
        //StringWriter: dotnet StringWriter;
        textb: TextBuilder;
        //string: str
        //JsonTextWriter: dotnet JsonTextWriter;
        //json: js
        DoNotFormat: Boolean;

    procedure ReadJSonToJSonBuffer(Json: Text; var JsonBuffer: Record "JSON Buffer")
    var
    begin
        JsonBuffer.ReadFromText(Json);
    end;
    /*
        local procedure InitializeWriter()
        var
        Formatting: dotnet Formatting;
        begin

             if not IsNull(StringBuilder) then
                exit;
            StringBuilder := StringBuilder.StringBuilder;
            StringWriter := StringWriter.StringWriter(StringBuilder);
            JsonTextWriter := JsonTextWriter.JsonTextWriter(StringWriter);
            if DoNotFormat then
                JsonTextWriter.Formatting := Formatting.None
            else
                JsonTextWriter.Formatting := Formatting.Indented;
        end;
    */
    /*
            procedure SetDoNotFormat()
            begin
                DoNotFormat := true;
            end;
    */
    /*
            procedure WriteStartConstructor(Name: Text)
            begin
                InitializeWriter;

                JsonTextWriter.WriteStartConstructor(Name);
            end;
    */
    /*
            procedure WriteEndConstructor()
            begin
                JsonTextWriter.WriteEndConstructor;
            end;
    */
    /*
            procedure WriteStartObject(ObjectName: Text)
            begin
                InitializeWriter;

                if ObjectName <> '' then
                    JsonTextWriter.WritePropertyName(ObjectName);
                JsonTextWriter.WriteStartObject;
            end;
    */
    /*
            procedure WriteEndObject()
            begin
                JsonTextWriter.WriteEndObject;
            end;
    */
    /*
            procedure WriteStartArray(ArrayName: Text)
            begin
                InitializeWriter;

                if ArrayName <> '' then
                    JsonTextWriter.WritePropertyName(ArrayName);
                JsonTextWriter.WriteStartArray;
            end;
    */
    /*
            procedure WriteEndArray()
            begin
                JsonTextWriter.WriteEndArray;
            end;
    */
    /*
            procedure WriteStringProperty(VariableName: Text; Variable: Variant)
            begin
                JsonTextWriter.WritePropertyName(VariableName);
                JsonTextWriter.WriteValue(Format(Variable, 0, 9));
            end;
    */
    /*
            procedure WriteNumberProperty(VariableName: Text; Variable: Variant)
            var
                Decimal: Decimal;
            begin
                case true of
                    Variable.Isinteger, Variable.IsDecimal:
                        Decimal := Variable;
                    else
                        Evaluate(Decimal, Variable);
                end;
                JsonTextWriter.WritePropertyName(VariableName);
                JsonTextWriter.WriteValue(Decimal);
            end;
    */
    /*
            procedure WriteBooleanProperty(VariableName: Text; Variable: Variant)
            var
                Bool: Boolean;
            begin
                case true of
                    Variable.ISBOOLEAN:
                        Bool := Variable;
                    else
                        Evaluate(Bool, Variable);
                end;
                JsonTextWriter.WritePropertyName(VariableName);
                JsonTextWriter.WriteValue(Bool);
            end;
    */
    /*
            procedure WriteNullProperty(VariableName: Text)
            begin
                JsonTextWriter.WritePropertyName(VariableName);
                JsonTextWriter.WriteNull;
            end;
    */
    /*
            procedure WriteBytesProperty(VariableName: Text; TempBlob: Record TempBlob)
            var
                //MemoryStream: dotnet MemoryStream;
                InStr: InStream;
            begin
                TempBlob.Blob.CreateInstream(InStr);
                MemoryStream := MemoryStream.MemoryStream;
                CopyStream(MemoryStream, InStr);
                JsonTextWriter.WritePropertyName(VariableName);
                JsonTextWriter.WriteValue(MemoryStream.ToArray);
            end;
    */
    /*
            procedure WriteRawProperty(VariableName: Text; Variable: Variant)
            begin
                JsonTextWriter.WritePropertyName(VariableName);
                JsonTextWriter.WriteValue(Variable);
            end;
    */
    /*
            procedure GetJSonAsText() JSon: Text
            begin
                JSon := StringBuilder.ToString;
            end;
    */
    /*
            procedure WriteValue(Variable: Variant)
            begin
                JsonTextWriter.WriteValue(Variable);
            end;
    */
    /*
            procedure WriteProperty(VariableName: Text)
            begin
                JsonTextWriter.WritePropertyName(VariableName);
            end;
    */
    procedure FormatAmountCSV(Amt: Decimal): Code[20]
    var
        AmountInTxt: Text[20];
        DecimalsTxt: Text;
    begin
        //AmountInTxt :=FORMAT(ROUND(Amt,0.01),0,'<Integer><Decimals>');
        DecimalsTxt := CopyStr(Format(ROUND(Amt, 0.01), 0, '<Decimals>'), 2);
        if DecimalsTxt <> '' then
            AmountInTxt := Format(Amt, 0, '<Integer>,') + DecimalsTxt
        else
            AmountInTxt := Format(Amt, 0, '<Integer>');
        exit(AmountInTxt);
    end;

    procedure FormatDateCSV(RecDate: Date): Code[14]
    var
        DateInTxt: Text[20];
    begin
        DateInTxt := Format(RecDate, 0, '<Year4><Month,2><Day,2>') + '000000';
        exit(DateInTxt);
    end;

    procedure FormatTimeCSV(RecDate: Date; RecTime: Time): Code[14]
    var
        TimeInTxt: Text[20];
    begin
        //>> ZSRED30 201229 LKA
        //TimeInTxt :=FORMAT(RecDate,0,'<Year4><Month,2><Day,2>') + FORMAT(RecTime,0,'<Hour,2><Minutes,2>')+'00';
        TimeInTxt := Format(RecDate, 0, '<Year4><Month,2><Day,2>') + Format(RecTime, 0, '<Hours24,2><Filler Character,0><Minutes,2>') + '00';
        //<< ZSRED30 201229 LKA
        exit(TimeInTxt);
    end;
}
