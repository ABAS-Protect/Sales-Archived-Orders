/*
    Author: Niklas Dougherty <nd@abas.se>
    Date: 2026-08-19
    Description: Store variant in a buffer table.
*/

table 50102 "Variant Filter Buffer"
{
    Caption = 'Variant Filter Buffer';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
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