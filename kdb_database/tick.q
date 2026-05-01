// kdb_database/tick.q
// Stripped down, highly-efficient publisher

system "p 5000" // Run tick plant on port 5000

// Load the schema
\l schema.q

// Tables list
.u.t:tables[]

// Initialize log file
.u.L:`$":./tplog_",string[.z.D],".log"
.[.u.L;();:;()] // Create file if it doesn't exist

// Pub/Sub logic
.u.w:()!()
sub:{[t] .u.w[t]:.u.w[t],.z.w; (t;value t)}

// Ingestion function (called by external feeds)
upd:{[t;x]
    // Append to memory
    insert[t;x];
    // Log to disk for fault tolerance
    .[.u.L;();,;(t;x)];
    // Publish to subscribers (RDB)
    if[count .u.w t; (neg .u.w t)@\:( `upd;t;x )]
    }