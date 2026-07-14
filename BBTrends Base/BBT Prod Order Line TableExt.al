TableExtension 50156 "BBT Prod. Order Line" extends "Prod. Order Line"
{
    fields
    {
        field(50000; "Item Category Code"; Code[20])
        {
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("Item No.")));
            Caption = 'Item Category Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Item Category";
        }
        field(50002; "Item Tracking Code"; Code[10])
        {
            CalcFormula = lookup(Item."Item Tracking Code" where("No." = field("Item No.")));
            Caption = 'Item Tracking Code';
            FieldClass = FlowField;
            TableRelation = "Item Tracking Code";
        }
        field(50003; "Repetir Lote"; Code[20])
        {
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."));
            ObsoleteState = Removed;    // BBT 01/07/2025
        }
        field(50004; "Tiempo Total"; Decimal)
        {
            ObsoleteState = Removed;    // BBT 01/07/2025
        }
        field(50005; "Cód. Turno"; Code[10])
        {
            TableRelation = "Work Shift";
            ObsoleteState = Removed;    // BBT 01/07/2025
        }
    }

    //>> BBT. 01/07/2025. PRECINTIA
    /*
    procedure CalcularTiempo()
    var
        horas: Decimal;
        //DateAndTime: dotnet DateAndTime;
        //DayOfWeekInput: dotnet FirstDayOfWeek;
        //WeekOfYearInput: dotnet FirstWeekOfYear;
        minutos: Decimal;
        Fecha1: DateTime;
        Fecha2: DateTime;
        rCalenTurnos: Record "Shop Calendar Working Days";
        DiaSemana: Integer;
    begin
        // FHS
        DiaSemana := Date2dwy(Rec."Starting Date", 1);
        //minutos:=DateAndTime.DateDiff('N',Rec."Starting Date-Time",Rec."Ending Date-Time",DayOfWeekInput.Monday,WeekOfYearInput);
        minutos := Round((Rec."Ending Date-Time" - Rec."Starting Date-Time") / 60000, 1, '=');
        horas := minutos / 60;
        Rec."Tiempo Total" := horas;
        rCalenTurnos.Reset;
        rCalenTurnos.SetFilter("Starting Time", '>%1', Rec."Starting Time");
        rCalenTurnos.SetRange(Day, DiaSemana);
        if rCalenTurnos.FindSet() then Rec."Cód. Turno" := rCalenTurnos."Work Shift Code";
    end;
    */
    //<<
}
