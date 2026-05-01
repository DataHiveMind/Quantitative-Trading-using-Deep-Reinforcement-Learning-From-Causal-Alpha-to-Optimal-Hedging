// kdb_database/schema.q
// Define the base tables for the Tick Plant

// Trade Table: Executed transactions
trade:([]
    time:`timespan$(); 
    sym:`symbol$(); 
    price:`float$(); 
    size:`long$(); 
    side:`char$()       // 'B' for Buy, 'S' for Sell
    );

// Quote Table: Top of book (Level 1 LOB)
quote:([]
    time:`timespan$(); 
    sym:`symbol$(); 
    bid:`float$(); 
    ask:`float$(); 
    bsize:`long$(); 
    asize:`long$()
    );

// Limit Order Book Snapshots (Level 2+ Depth)
lob_snapshot:([]
    time:`timespan$();
    sym:`symbol$();
    bids:`float$();     // List of bid prices
    asks:`float$();     // List of ask prices
    bsizes:`long$();    // List of bid sizes
    asizes:`long$()     // List of ask sizes
    );