TableExtension 50178 "BBT Posted Whse. Ship Header" extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(50006; "No. entrega almacen"; Code[20])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
        }
    }
}
