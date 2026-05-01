// kdb_database/r.q
// In-memory intraday database

system "p 5001" // Run RDB on port 5001

// Connect to tick plant on port 5000
h:hopen `::5000

// Define upd function to handle incoming data from tick plant
upd:{[t;x] insert[t;x]}

// Subscribe to all tables
(tables[]; data) : h "sub[`]"

// End of Day (EOD) function to flush RAM to HDB
.u.end:{[d]
    hdb_dir: `$":./hdb/",string[d],"/";
    {[dir;t] 
        // Save table to date-partitioned directory
        .[`$string[dir],string[t],"/"; (); :; .Q.en[`$":./hdb"; value t]];
        // Clear memory
        delete from t;
    }[hdb_dir] each tables[];
    }

// Trigger EOD automatically at midnight
.z.ts:{if[.z.D > .z.d; .u.end[.z.d]; .z.d:.z.D]}
system "t 1000" // Check every second