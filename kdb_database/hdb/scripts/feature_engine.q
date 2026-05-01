// kdb_database/scripts/feature_engine.q
// Engineered features for DRL State Spaces

// Function to enrich the quote table with microstructure features
enrich_quotes:{[tbl]
    update 
        mid_price: (bid + ask) % 2.0,
        spread: ask - bid,
        // Order Book Imbalance: strictly bounded [-1, 1]
        // Values -> 1 indicate strong buying pressure, -> -1 strong selling
        obi: (bsize - asize) % (`float$bsize + asize),
        // Micro-Price: Size-weighted mid price
        micro_price: ((bid * asize) + (ask * bsize)) % (`float$bsize + asize)
    from tbl
    }

// Function to compute rolling flow toxicity (VPIN proxy)
// Calculates absolute volume imbalance over a sliding window (w)
flow_toxicity:{[tbl; w]
    update 
        vol_imbalance: mavg[w; size * (2 * (`long$(side=`B)) - 1)] 
    from tbl
    }

// Example usage to pull a state vector for the RL environment:
// get_state[`AAPL; 09:30:00.000; 10:00:00.000]
get_state:{[ticker; start_t; end_t]
    base_data: select from quote where sym=ticker, time within (start_t; end_t);
    enriched: enrich_quotes[base_data];
    :enriched
    }