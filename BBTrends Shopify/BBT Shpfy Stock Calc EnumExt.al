enumextension 73100 "BBT Stock Calc Ext" extends "Shpfy Stock Calculation"
{
    value(73100; "BB Trends")
    {
        Caption = 'BB Trends';
        Implementation = "Shpfy Stock Calculation" = "BBT Shpfy Stock Calculation", "Shpfy IStock Available" = "Shpfy Can Have Stock";
    }
}
