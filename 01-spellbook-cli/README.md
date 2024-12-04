# Spellbook CLI

## Goal

Create a CLI application for managing and executing "spells" (tasks) in the terminal, using Elixir.

```sh
$ spellbook
```

## Requirements

The application should perform CRUD operations on a local data file of spells. Each operation should be accessible via a CLI command. The operations are as follows:

### Add

Create new spells by providing a description via the `add` command:

```sh
$ spellbook add 
```

For example:

```sh
$ spellbook add “Learn Phoenix LiveView basics”
```

should add a new "spell" with the description "Learn Phoenix LiveView basics."

### List

Display all **active** (not completed) spells. Use a flag to display all spells regardless of status:

```sh
$ spellbook list
```

For example:

```sh
ID    Spell Description                         Created
1     Learn Phoenix LiveView basics            a minute ago
2     Understand OTP and GenServer             10 seconds ago
```

To show all spells (active and completed):

```sh
$ spellbook list -a
ID    Spell Description                        Created          Completed
1     Learn Phoenix LiveView basics            2 minutes ago    false
2     Understand OTP and GenServer             a minute ago     true
```

### Complete

Mark a spell as completed:

```sh
$ spellbook complete <spell_id>
```

For example:

```sh
$ spellbook complete 1
```

### Delete

Remove a spell permanently from the data file:

```sh
$ spellbook delete <spell_id>
```

For example:

```sh
$ spellbook delete 2
```

## Notable Packages Used

- [Nexus](https://hex.pm/packages/nexus_cli) for CLI command parsing and execution.
- [File](https://hexdocs.pm/elixir/File.html) and [IO](https://hexdocs.pm/elixir/IO.html) modules for reading and writing to the local file system.
- [DateTime](https://hexdocs.pm/elixir/DateTime.html) for managing timestamps.
- [Jason](https://hex.pm/packages/jason) for JSON serialization and deserialization if you're using erlang/otp pre v27. If you're using erlang/otp v27+ then you can use the [json](https://www.erlang.org/doc/apps/stdlib/json.html#) module from standard library.

## Custom Resources

### Example Application

You can find an example implementation of this CLI tool in the [releases](https://github.com/zoedsoupe/arcane-quests/releases) section.

### Example Data File

A JSON-based data file might look like this:

```json
[
  {
    "id": 1,
    "description": "Learn Phoenix LiveView basics",
    "created_at": "2024-12-04T15:00:00Z",
    "is_completed": false
  },
  {
    "id": 2,
    "description": "Understand OTP and GenServer",
    "created_at": "2024-12-04T15:05:00Z",
    "is_completed": true
  }
]
```

## Technical Considerations

### File Locking

To prevent concurrent read/write issues with the data file, ensure exclusive access using Elixir’s [File.open/2](https://hexdocs.pm/elixir/File.html#open/2) with appropriate modes.

### Error Handling

Provide clear error messages for invalid commands, such as attempting to complete or delete a spell that does not exist.

## Extra Features

-	Add a due date field to spells to help prioritize tasks.
-	Support a remind command to list spells due soon.
-	Implement a search feature to find spells by keywords in their description.
-	Enhance the data store from JSON to SQLite for more advanced features.


