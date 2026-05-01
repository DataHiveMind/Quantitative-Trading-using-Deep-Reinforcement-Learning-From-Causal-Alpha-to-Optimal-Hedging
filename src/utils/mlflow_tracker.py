import mlflow
import os
import yaml

class RL_MLflowTracker:
    def __init__(self, config_path="configs/mlflow_config.yaml", experiment_name="Nexus_Causal_Alpha"):
        # Load config
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f)
        
        # Set tracking URI (can be local ./mlruns or remote like AWS/GCP)
        tracking_uri = self.config.get("tracking_uri", "file:./mlruns")
        mlflow.set_tracking_uri(tracking_uri)
        
        # Set experiment
        mlflow.set_experiment(experiment_name)
        self.run = None

    def start_run(self, run_name=None):
        """Starts a new MLflow run."""
        self.run = mlflow.start_run(run_name=run_name)
        return self.run

    def log_params(self, params_dict):
        """Log agent hyperparameters (e.g., learning_rate, gamma, batch_size)."""
        if self.run:
            mlflow.log_params(params_dict)

    def log_financial_metrics(self, step, sharpe, sortino, max_drawdown, total_return):
        """Log trading-specific metrics during/after backtesting."""
        if self.run:
            mlflow.log_metric("Sharpe_Ratio", sharpe, step=step)
            mlflow.log_metric("Sortino_Ratio", sortino, step=step)
            mlflow.log_metric("Max_Drawdown", max_drawdown, step=step)
            mlflow.log_metric("Total_Return", total_return, step=step)

    def log_rl_metrics(self, step, actor_loss, critic_loss, mean_reward):
        """Log neural network training metrics."""
        if self.run:
            mlflow.log_metric("Actor_Loss", actor_loss, step=step)
            mlflow.log_metric("Critic_Loss", critic_loss, step=step)
            mlflow.log_metric("Mean_Episode_Reward", mean_reward, step=step)

    def save_model(self, model_path, artifact_path="drl_models"):
        """Uploads the saved PyTorch/SB3 model to the MLflow artifact store."""
        if self.run:
            mlflow.log_artifact(model_path, artifact_path=artifact_path)

    def end_run(self):
        """Ends the current run."""
        if self.run:
            mlflow.end_run()