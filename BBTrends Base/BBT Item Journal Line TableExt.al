TableExtension 50120 "BBT Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(50000; "Posting Date ILE"; Date)
        {
            Caption = 'Posting Date ILE', comment = 'ESP="Fecha registro Mov Prod."';
        }
    }
    local procedure TimeToDecimal(TimeP: Time): Decimal
    var
        Result: Decimal;
        TymStr: Text;
    begin
        TymStr := Format(TimeP);
        TymStr := DelStr(TymStr, (StrLen(TymStr) - 1), 2);
        TymStr := DelChr(TymStr, '=', ':');
        Evaluate(Result, TymStr);
        exit(Result);
    end;

    var
        vTime: Time;
        cDuration: Duration;
        gDec_Value: Decimal;
        d1: DateTime;
        d2: DateTime;
        rWorkCenter: Record "Work Center";
        rCalenPlanta: Record "Shop Calendar Working Days";
        DayOfWeek: Integer;
}
