# Quantitative-Trading-using-Deep-Reinforcement-Learning-From-Causal-Alpha-to-Optimal-Hedging

![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)
![kdb+/q](https://img.shields.io/badge/kdb%2B%2Fq-Tick-orange.svg)
![C++](https://img.shields.io/badge/C%2B%2B-17-purple.svg)
![RL](https://img.shields.io/badge/Reinforcement_Learning-PPO%2FSAC-brightgreen.svg)

## Abstract
Modern quantitative trading systems are increasingly plagued by signal fragility, siloed research workflows, and an inability to adapt to non-stationary market regimes. While deep learning has expanded the search space for alpha, it often captures spurious correlations that fail under real-world complexity. 

**Quant DRL Trading Project** is a Unified Reinforcement Learning Framework that integrates the entire lifecycle of a systematic strategy into a single, reproducible research pipeline. By synthesizing causal discovery, adaptive allocation, and realistic execution, this work contributes a scalable and defensible methodology for the next generation of AI-driven trading systems.

## 🏗 System Architecture

The platform is designed with an institutional-grade separation of concerns, built to operate efficiently across distributed hardware—leveraging local machines for high-frequency data processing and cloud environments for heavy deep learning compute.

1. **The Data Engine (Local/On-Prem):** A `kdb+/q` tick architecture ingests raw market data, computes complex order book features (e.g., imbalance, flow toxicity), and writes to a Historical Database (HDB).
2. **The Bridge:** The custom `flat_file_wizard` extracts engineered features from `kdb+` and serializes them into optimized flat files (Parquet).
3. **The Brain (Google Colab/Cloud):** The flat files are ingested into Google Colab, where the heavy Deep Reinforcement Learning (DRL) agents are trained across various regimes.
4. **The Execution Simulator:** A high-performance C++ matching engine, exposed to Python via PyBind11, allows DRL execution agents to navigate realistic liquidity constraints during training.

## 🧠 Core Modules

* **Causal Alpha Discovery:** Introduces Causal Reinforcement Learning (CRL) to isolate robust, structural drivers of price action from regime-dependent noise, moving beyond simple correlation.
* **Regime-Aware DRL Allocator:** Dynamically manages capital and portfolio sizing based on evolving market conditions detected via Hidden Markov Models (HMMs).
* **Multi-Agent Order Book Execution:** Trains RL agents within a C++ Limit Order Book (LOB) environment to optimize execution while navigating microstructure dynamics and minimizing slippage.
* **Advanced Risk Management:** Benchmarks autonomous DRL hedging strategies against classical stochastic volatility models (e.g., Heston, SABR) to ensure structural robustness across extreme market stress scenarios.

## 🚀 Environment Setup

### 1. kdb+/q Data Pipeline (Local)

Ensure you have a kdb+ instance running. The tick architecture handles raw ingestion and feature generation.
```bash
# Start the tick plant and historical database
q kdb_database/tick.q -p 5000
q kdb_database/hdb/ -p 5001
```

### 2. Exporting Data

Use the Python client to bridge kdb+ output to Colab-friendly formats
```bash
python src/data_pipeline/flat_file_wizard.py --source kdb --target data/processed/ --format parquet
```

### 3. C++ Microstructure Engine

Complie the matching engine bindings before training execution agents
```bash
cd src/execution
make pybind
```

### 4. Model training (Google Colab)

Upload the processed flat files to Google Drive. Mount your drive in the colab notebooks located in research/notebooks/ to begin training the agents without data ingestion bottlenecks.

### 5. MLOps & Experiment Tracking (MLflow)

Because this framework relies on non-stationary market adaptations and multiple interacting RL agents, **MLflow** is integrated for comprehensive model governance.

To start the tracking server and visualize your agent's training curves and financial metrics (Sharpe, Drawdown):
```bash
# Start the local MLflow UI
bash mlops/start_mlflow_server.sh

# Or run manually
mlflow ui --host 0.0.0.0 --port 5000
```
Navigate to http://localhost:5000 to view the experiment dashboard.

Tracking Capabilities:

-   Hyperparameter Logging: Automatically tracks configurations across CRL, Allocator, and Execution agents.

-   Metric Tracking: Logs RL-specific metrics (Actor/Critic Loss) alongside financial metrics (Sortino Ratio, Cumulative Return) at every evaluation epoch.

-   Model Registry: Trained .pt and .zip weights are saved as artifacts, allowing seamless promotion of agents from Staging to Production based on risk-adjusted backtest performance.


## 📂 Repository Structure

src/: Core pipeline logic (Data, Causal Alpha, Allocation, Execution, Risk).

kdb_database/: High-frequency tick data architecture and q-SQL scripts.

configs/: YAML configurations for hyperparameter and backtest friction tuning.

research/: Mathematical derivations, standalone stress testing (RARL), and Colab notebooks.

## 👨‍💻 Author
Kenneth Leagre
Quantitative Research / Applied Mathematics

Disclaimer: This repository is for academic and quantitative research purposes. The strategies developed within do not constitute financial advice.