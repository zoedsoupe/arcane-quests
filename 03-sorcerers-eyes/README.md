# Sorcerer's Eye Monitoring

## Goal

Create a distributed system monitoring tool called `sorcerers_eye` that collects and displays real-time metrics from nodes in a distributed system. This project showcases [GenServers](https://hexdocs.pm/elixir/GenServer.html), [Supervisors](https://hexdocs.pm/elixir/Supervisor.html), and Elixir's focus on fault tolerance and resilience.

```sh
$ mix new sorcerers_eye --sup
```

## Requirements

The application should monitor connected nodes, gather system metrics (e.g., memory usage, CPU load, process counts), and display them in real-time via a simple CLI or web interface.

### Node Discovery

Automatically discover nodes in a distributed system:
-	Use Elixir’s Node module to connect to other nodes.
-	Maintain a registry of connected nodes.

### Metrics Collection

Gather system metrics from each node, including:
-	Memory usage
-	CPU load
-	Process counts
-	Uptime

Use Erlang’s :os module and Elixir’s System module for metric collection.

### Real-Time Updates

Ensure that metrics are updated in real-time:
-	Use a GenServer process to poll metrics at regular intervals.
-	Broadcast updates to the UI using Phoenix PubSub or a custom mechanism.

### Fault Tolerance

Implement fault-tolerant processes:
-	Use Supervisors to restart GenServers that fail.
-	Gracefully handle node disconnections and reconnections.

### CLI or Web Interface

Display metrics using:
-	A CLI-based interface that lists metrics for each node.
-	Alternatively, a Phoenix LiveView web interface for a more visual display.

## Example Features

### CLI Interface

```
$ sorcerers_eyes fetch
Node: mystic-node-1
Memory Usage: 512MB
CPU Load: 20%
Process Count: 100
Uptime: 2 hours

Node: mystic-node-2
Memory Usage: 1GB
CPU Load: 50%
Process Count: 200
Uptime: 5 hours
```

### Web Interface

Display metrics in a table with real-time updates:

```
Node	Memory Usage	CPU Load	Process Count	Uptime
mystic-node-1	512MB	20%	100	2 hours
mystic-node-2	1GB	50%	200	5 hours
```

## Notable Packages Used

-	[GenServer](https://hexdocs.pm/elixir/GenServer.html) for managing metric collection processes.
-	[Supervisor](https://hexdocs.pm/elixir/Supervisor.html) for process supervision.
- [libcluster](https://hexdocs.pm/libcluster/readme.html) for easy distributed node discory
-	[Phoenix PubSub](https://hexdocs.pm/phoenix_pub_sub) for real-time communication (optional for the web version).
- [Nexus](https://https://hexdocs.pm/nexus_cli) as CLI framework (optional for the CLI version).

## Custom Resources

### Example Application

You can find an example implementation of this monitoring tool in the [releases ]section.

### Example GenServer Implementation

A simple GenServer for collecting metrics:

```ex
defmodule SorcerersEye.MetricsCollector do
  use GenServer

  def start_link(node_name) do
    GenServer.start_link(__MODULE__, node_name, name: via_tuple(node_name))
  end

  @impl true
  def init(node_name) do
    {:ok, %{node_name: node_name, metrics: %{}}, {:continue, :collect_metrics}}
  end

  @impl true
  def handle_continue(:collect_metrics, state) do
    schedule_metrics_collection()
    {:noreply, collect_metrics(state)}
  end

  @impl true
  def handle_info(:collect_metrics, state) do
    schedule_metrics_collection()
    {:noreply, collect_metrics(state)}
  end

  defp collect_metrics(state) do
    metrics = %{
      memory: :os.system_info(:memory),
      cpu: :os.system_info(:cpu_load),
      process_count: length(Process.list())
    }

    %{state | metrics: metrics}
  end

  defp schedule_metrics_collection do
    Process.send_after(self(), :collect_metrics, 5_000)
  end
end
```

### Example Supervisor Tree

```ex
defmodule SorcerersEye.Application do
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: SorcerersEye.NodeSupervisor}
    ]

    opts = [strategy: :one_for_one, name: SorcerersEye.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

## Technical Considerations

### Distributed Setup

Run the application across multiple nodes:
-	Start nodes with the --name flag: `iex --sname mystic-node-1 -S mix`.
-	Use Node.connect/1 to establish connections between nodes.

### Resilience

Ensure processes are supervised to handle failures gracefully:
-	Restart failed GenServers.
-	Handle node disconnections with retries or fallback behavior.

### Scalability

For large systems, optimize by batching metric collection or reducing polling frequency.

## Extra Features

-	Display metrics in a dashboard with graphs (if using Phoenix LiveView).
-	Add alerts for high CPU or memory usage.
-	Allow filtering metrics by node or resource type.
-	Save historical metrics to a database for analysis.
-	Implement a CLI command to trigger garbage collection on remote nodes.
- Implement a `observe` command for real-time tracking (if using CLI version)


