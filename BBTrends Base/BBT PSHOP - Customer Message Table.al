Table 50028 "PSHOP - Customer Message"
{
    Caption = 'Mensaje cliente Prestashop';

    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; "Customer Thread Id"; Integer)
        {
            TableRelation = "PSHOP - Customer Thread".id;
        }
        field(2; id; Integer)
        { }
        field(3; id_employee; Integer)
        { }
        field(4; id_customer_thread; Integer)
        { }
        field(5; ip_address; Text[50])
        { }
        field(6; message; Blob)
        { }
        field(7; file_name; Text[50])
        { }
        field(8; user_agent; Text[150])
        { }
        field(9; private; Integer)
        { }
        field(10; date_add; DateTime)
        { }
        field(11; date_upd; DateTime)
        { }
        field(12; read; Integer)
        { }
        field(13; "Site Code"; Code[10])
        {
            TableRelation = "PSHOP - Site".Code;
        }
        field(20; id_order; Integer)
        {
            CalcFormula = lookup("PSHOP - Customer Thread".id_order where(id = field("Customer Thread Id")));
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "Site Code", "Customer Thread Id", id)
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
    procedure SetCustMessageText(MessageText: Text)
    var
        OStream: OutStream;
    begin
        Clear(message);
        message.CreateOutstream(OStream);
        OStream.WriteText(MessageText);
    end;

    procedure GetCustMessageText() CustMessageText: Text
    var
        IStream: InStream;
        DummText: Text;
    begin
        CustMessageText := '';
        CalcFields(message);
        message.CreateInstream(IStream);
        while not IStream.eos do begin
            IStream.ReadText(DummText);
            CustMessageText += DummText;
        end;
    end;
}
