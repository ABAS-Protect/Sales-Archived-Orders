/*
    Author: Niklas Dougherty <nd@abas.se>
    Date: 2026-08-19
    Description: Store variant in a buffer table.
*/
table 50102 "Variant Filter Buffer"
{
    Caption = 'Variant Filter Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Variant Code")
        {
            Clustered = true;
        }
    }
}