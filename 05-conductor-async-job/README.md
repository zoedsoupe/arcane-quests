# Alchemist's Task Scheduler

## Goal

Create a background job processing system called `conductor` to manage job queues, workers, and scheduling. This project demonstrates the use of [OTP behaviors](https://hexdocs.pm/elixir/GenServer.html) such as `GenServer` and `Supervisor`, highlighting the [BEAM's](https://www.erlang.org/doc/white_paper.html) ability to handle concurrency and back-pressure efficiently.

```sh
$ mix new conductor --sup
```

## Requirements

The application should manage a queue of background jobs, execute them with workers, and gracefully handle job failures or retries.

### Job Queues

-	Create a queue to store jobs.
-	Jobs should include:
  -	Unique ID
  -	Payload (e.g., JSON data or Elixir map)
  -	Status (`pending`, `in_progress`, `completed`, `failed`)
  -	Retry count and max retries

### Worker Processes

-	Spawn worker processes to execute jobs from the queue.
-	Limit the number of concurrent workers to control system load.

### Job Scheduling

-	Support immediate and scheduled job execution:
  -	Immediate jobs are executed as soon as a worker is available.
  -	Scheduled jobs are executed after a specified delay.

### Failure Handling and Retries

-	Automatically retry failed jobs up to a configurable maximum.
-	Track failure reasons and logs for debugging.

### Monitoring and Metrics

- 	Provide a CLI command or web dashboard to view job statuses and queue health:
- 	Total jobs
- 	Completed jobs
- 	Failed jobs
- 	Pending jobs
- 	In-progress jobs

## Example Features

### Enqueue a Job

```sh
$ conductor enqueue --payload '{ "task": "send_email", "email": "test@example.com" }'
```

### View Job Queue

```sh
$ conductor jobs
ID    Task           Status       Retries
1     send_email     pending      0
2     data_import    in_progress  1
```

## Notable Packages Used

-	[GenServer](https://hexdocs.pm/elixir/GenServer.html) for job queue and worker processes.
-	[DynamicSupervisor](https://hexdocs.pm/elixir/DynamicSupervisor.html) for managing worker processes.
-	[Ecto](https://hexdocs.pm/ecto) for persistent job storage (optional).
-	[Telemetry](https://hexdocs.pm/telemetry/readme.html) for monitoring job metrics.
- [Oban](https://hexdocs.pm/oban) for inspiration as a async job queue processing (backed with postgresql)

## Custom Resources

### Example Application

You can find an example implementation of this task scheduler in the [releases]section.

### Example Job Queue Implementation

A simple GenServer for managing the job queue:

```ex
defmodule Conductor.JobQueue do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def enqueue(job) do
    GenServer.call(__MODULE__, {:enqueue, job})
  end

  def fetch_next() do
    GenServer.call(__MODULE__, :fetch_next)
  end

  def init(_) do
    {:ok, []}
  end

  def handle_call({:enqueue, job}, _from, state) do
    {:reply, :ok, [job | state]}
  end

  def handle_call(:fetch_next, _from, [next | rest]) do
    {:reply, {:ok, next}, rest}
  end

  def handle_call(:fetch_next, _from, []) do
    {:reply, :empty, []}
  end
end
```

### Example Worker Implementation

```ex
defmodule Conductor.Worker do
  use GenServer

  def start_link(job) do
    GenServer.start_link(__MODULE__, job, name: via_tuple(job.id))
  end

  def init(job) do
    Task.start(fn -> execute(job) end)
    {:ok, job}
  end

  defp execute(%{payload: payload} = job) do
    # Simulate job execution
    IO.inspect(payload, label: "Executing Job")
    :timer.sleep(1000)

    # Handle success or failure
    case :rand.uniform(10) > 2 do
      true -> IO.puts("Job #{job.id} completed successfully.")
      false -> IO.puts("Job #{job.id} failed.")
    end
  end
end
```

## Technical Considerations

### Back-Pressure Management

-	Limit the number of concurrent workers using `DynamicSupervisor`.
-	Pause job fetching when the system is under heavy load.

### Persistent Storage

-	Use `Ecto` or a simple `ETS` table to persist jobs and their statuses.
-	Store job metadata for debugging and monitoring.

### Resilience

-	Restart failed worker processes with `DynamicSupervisor`.
-	Retry failed jobs based on a backoff strategy (e.g., exponential backoff).

## Extra Features

-	Add priority levels to jobs (e.g., high, medium, low).
-	Implement job cancellation by ID.
-	Provide a web dashboard using Phoenix LiveView for monitoring and managing jobs.
-	Support cron-like periodic job scheduling.
-	Integrate Telemetry events for Prometheus or other monitoring tools.


