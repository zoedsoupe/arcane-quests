# Mystic Web Crawler

## Goal

Create a concurrent web crawler called `scryer` to fetch and process web pages asynchronously. This project demonstrates [Elixir's](https://elixir-lang.org/) concurrency model and the actor model for efficient task management. It also highlights the use of [Supervisors](https://hexdocs.pm/elixir/Supervisor.html) to handle process failures gracefully.

```sh
$ mix new scryer --sup
```

## Requirements

The application should recursively crawl a website, identify dead links (links returning 4xx or 5xx HTTP status codes), and report the results.

### Crawling Web Pages

-	Start crawling from a given URL.
-	Extract all links from the page.
-	Recursively visit links within the same domain.
-	Skip links pointing to external domains.

### Concurrent Processing

-	Use multiple processes to fetch and process web pages concurrently.
-	Limit the number of concurrent processes to avoid overwhelming the target server.

### Error Handling

-	Detect and log errors such as:
-	Dead links (HTTP 4xx or 5xx).
-	Timeouts or connection errors.
-	Use a Supervisor to restart failed processes.

### Results Aggregation

-	Collect and display the results in a structured format (e.g., a CLI table or JSON file):
-	Total number of links.
-	Number of dead links.
-	List of dead links with their status codes.

## Example Features

### CLI Input

Start the crawler with a URL:

```sh
$ scryer crawl https://example.com
```

### CLI Output

Display a summary of results:

```
Summary:
- Total Links: 50
- Dead Links: 5

Dead Links:
- https://example.com/broken1 (404)
- https://example.com/broken2 (500)
```

## Notable Packages Used

-	[Req](https://hexdocs.pm/req) or [Tesla](https://hexdocs.pm/tesla) for HTTP requests.
-	[Floki](https://hexdocs.pm/floki) for HTML parsing and extracting links.
-	[Task](https://hexdocs.pm/elixir/Task.html) for concurrent processing.
-	[Supervisor](https://hexdocs.pm/elixir/Supervisor.html) for process supervision.

## Custom Resources

### Example Application

You can find an example implementation of this web crawler in the [releases ]section.

### Example URL Filtering

A simple function to filter links:

```ex
defmodule Scryer.Filter do
  def filter_links(links, base_url) do
    Enum.filter(links, fn link ->
      URI.parse(link).host == URI.parse(base_url).host
    end)
  end
end
```

### Example Supervisor Tree

```ex
defmodule Scryer.Application do
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Scryer.CrawlerSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Scryer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

### Example crawler worker

```ex
defmodule Scryer.Worker do
  use Task

  def start_link(_opts) do
    Task.start_link(fn -> crawl() end)
  end

  defp crawl do
    # todo...
  end
end
```

## Technical Considerations

### Concurrency

-	Use [Task.async_stream/3](https://hexdocs.pm/elixir/Task.html#async_stream/3) to fetch pages concurrently while limiting the number of active tasks.

### Link Extraction

-	Parse HTML with Floki to find all `<a>` tags.
-	Resolve relative URLs to absolute URLs using [URI.merge/2](https://hexdocs.pm/elixir/URI.html#merge/2).

### Error Handling

-	Handle HTTP timeouts (429), connection failures (5xx), and invalid URLs gracefully.
-	Log errors and continue processing remaining pages.

### Rate Limiting

-	Add a delay between requests to avoid overwhelming the target server.
-	Use :timer.sleep/1 or a rate-limiting library.

## Extra Features

-	Save results to a file in JSON or CSV format.
-	Visualize crawling progress with a spinner or progress bar in the CLI.
-	Add support for sitemaps to enhance crawling efficiency.
-	Include an option to crawl external domains.
-	Integrate with a web dashboard to display crawling results in real-time.


