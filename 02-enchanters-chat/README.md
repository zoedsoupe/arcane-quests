# Phoenix Enchanter's Chat

## Goal

Create a real-time chat application using [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view), leveraging the BEAM's ability to handle thousands of concurrent connections.

```sh
$ mix phx.new enchanters
```

## Requirements

The application should allow users to join chat rooms, send messages, and see real-time updates without page reloads. Each feature should be implemented using Phoenix LiveView.

### Join a Chat Room

Users should be able to join a chat room by entering their name and selecting a room:

-	The root page (/) should display a form where users can input their name and choose a room.
-	Upon submission, they should be redirected to the room’s live view (/rooms/:room_name).

### Send Messages

Users in a chat room should be able to send messages:
-	Provide an input field and a submit button to send messages.
-	Display sent messages in real-time to all participants in the room.

### Real-Time Updates

Messages sent in a room should appear immediately for all users without requiring a page refresh. Use [Phoenix PubSub](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html) to broadcast updates across all connected clients.

### Persistent Storage

Messages can be persisted in a database using Ecto, allowing users to see the chat history when joining a room or in-memory using something like [ETS](https://www.erlang.org/doc/apps/stdlib/ets.html#)

### Example Features

#### Homepage

A simple form to join a chat room:

```
Welcome to Enchanter's Chat!
Name: [________]
Room: [________] [Join Room]
```

#### Chat Room

An interactive live page showing the chat history and allowing users to send messages:

```
Room: Magic Circle
[John]: Hello, everyone!
[Jane]: Hi, John! Ready for some magic?

[__________________________] [Send]
```

## Notable Packages Used

-	[Phoenix LiveView](https://hexdocs.pm/phoenix_live_view) for real-time updates.
-	[Ecto](https://hexdocs.pm/ecto) for data mapping and if you intend to persist messages into database
- [Peri](https://hexdocs.pm/peri) for data mapping and schema validation if you want to validate raw data and persist messages in-memory
-	[Phoenix PubSub](https://hexdocs.pm/phoenix_pub_sub) for broadcasting messages.
-	Tailwind CSS for simple styling (optional, you can safely use raw CSS).

## Custom Resources

### Example Application

You can find an example implementation of this chat application in the [releases]() section.

### Example Database Schema

If you intend to persist messages in database, a simple schema for messages could be:

```ex
defmodule Enchanters.Message do
  use Ecto.Schema

  schema "messages" do
    field :name, :string
    field :content, :string
    field :room, :string

    timestamps()
  end
end
```

### Example Routes

```ex
# lib/enchanters_web/router.ex

scope "/", EnchantersWeb do
  live "/", HomeLive, :index
  live "/rooms/:room_name", RoomLive, :index
end
```

## Technical Considerations

### Concurrency

Leverage the BEAM’s concurrency model to allow multiple users to interact with the system in real-time. Each room can be managed by a separate process, isolating the state and communication for better fault tolerance.

### Error Handling

Provide clear error messages for invalid inputs, such as trying to send an empty message or joining a non-existent room.

### Security

- Implement basic sanitization to prevent XSS attacks.

## Extra Features

-	Add user authentication for personalized chat experiences.
-	Allow users to create private rooms with passwords.
-	Add timestamps to messages for better context.
-	Display a list of active users in each chat room.
- Support markdown/html syntax for chat inputs
-	Support file or image sharing within the chat.


