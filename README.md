# Arcane Quests (elixir)

This repository contains readmes for five different [Elixir](elixir) projects designed to explore the unique strengths of the [Elixir](elixir) language and the [BEAM](beam).

Inside this repository are 5 directories, each representing a single project idea.

Each of the project ideas contains a README and any supplementary resources or advice to help you build the project.

## 01 - Spellbook CLI

This project is to build a simple CLI tool called `spellbook`. It allows users to manage and execute "spells" (tasks) stored in a local file system. This beginner-friendly project introduces [Elixir's](elixir) functional paradigm, providing a foundation for learning [Elixir's](elixir) core concepts.

## 02 - Phoenix Enchanter's Chat

This project is to build a real-time chat application using [Phoenix LiveView](phoenix), called `enchanters`. The project demonstrates the [BEAM's](beam) ability to handle thousands of concurrent connections and highlights the use of [Erlang's](erlang) actor model for seamless real-time communication.

## 03 - Sorcerer's Eye Monitoring

This project is to build a distributed system monitoring tool called `sorcerers_eye`. It collects and displays metrics across nodes, handling failures gracefully with [GenServers](genserver) and [Supervisors](supervisor). This project highlights [Elixir's](elixir) focus on fault tolerance and distributed systems.

## 04 - Mystic Web Crawler

This project is to build a concurrent web crawler called `scryer`. It asynchronously fetches and processes web pages using multiple processes, showcasing [Elixir's](elixir) concurrency and the actor model for efficient task management. It also highlights the benefits of process supervision to manage failures.

## 05 - Alchemist's Task Scheduler

This project is to build a background job processing system called `conductor`. It demonstrates how to use [OTP](erlang) behaviors to manage queues, workers, and job scheduling. The project emphasizes the [BEAM's](beam) ability to handle concurrency and back-pressure gracefully.

# General Getting Started Advice

For all projects, make sure you start off by creating a new Mix project with `mix new --sup <project_name>` and using the default OTP app structure.

Each project is an opportunity to explore [Elixir's](elixir) unique paradigms, combining functional programming, the actor model, and the [BEAM's](beam) resilience. Dive in and enjoy the arcane magic of [Elixir](elixir)!

## Thanks and inspirations
- [concept video by Dreams of Code for 5 golang projects](goprojects)

<!-- link aliases -->
[phoenix]: https://phoenixframework.org
[elixir]: https://hexdocs.pm/elixir/introduction.html
[erlang]: https://www.erlang.org
[beam]: https://www.erlang.org/blog/a-brief-beam-primer/
[nexus]: https://hexdocs.pm/nexus_cli
[genserver]: https://hexdocs.pm/elixir/GenServer.html
[supervisor]: https://hexdocs.pm/elixir/Supervisor.html
[goprojects]: https://youtu.be/gXmznGEW9vo
