# Language features

These features are considered as part of the language if they are either core language features or are part of the standard library.
The survey was conducted on the newest version of the languages at the time of writing (2023.03.27.).

## Languages

The APL and SQL languages were only included here for context.

| **Language** | **Paradigm**                                        |
| ------------ | --------------------------------------------------- |
| **APL**      | Array, Functional                                   |
| **C**        | Imperative, Procedural                              |
| **C#**       | Imperative, Object-oriented, Functional             |
| **C++**      | Imperative, Procedural, Object-oriented, Generic    |
| **Clojure**  | Functional, Concurrent, Logic, Meta, Agent-oriented |
| **Elixir**   | Functional, Concurrent, Distributed                 |
| **Go**       | Concurrent, Imperative                              |
| **Haskell**  | Functional                                          |
| **Java**     | Object-oriented, Imperative                         |
| **JS/TS**    | Object-oriented, Imperative, Functional             |
| **Kotlin**   | Object-oriented, Functional, Concurrent, Generic    |
| **Lisp**     | Functional, Procedural, Meta                        |
| **PHP**      | Imperative, Object-oriented, Functional             |
| **Prolog**   | Logical, Meta                                       |
| **Python**   | Imperative, Object-oriented, Functional             |
| **Ruby**     | Object-oriented, Imperative                         |
| **Rust**     | Imperative, Object-oriented, Functional             |
| **SQL**      | Logical                                             |
| **V**        | Imperative, Procedural                              |
| **Zig**      | Imperative, Procedural                              |

## Multithreading/Concurrency

Basic threads and fibers (lightweight threads) and inter-process communication throug PIDs are also available in most of these
languages but those aren't particularly interesting. It is important to note that coroutine like functionality can
be easy implemented with generators and threads.

| **Language** | **Coroutines** | **Async/Await Promise/Future/Task** | **Channels/Pipes/Send & Receive** |
| ------------ | -------------- | ----------------------------------- | --------------------------------- |
| **C**        | No             | No                                  | No                                |
| **C#**       | No             | Yes                                 | Yes                               |
| **C++**      | Yes            | Yes                                 | No                                |
| **Clojure**  | No             | Yes                                 | Yes                               |
| **Elixir**   | No             | Yes                                 | Yes                               |
| **Go**       | Yes            | Yes                                 | Yes                               |
| **Haskell**  | Yes            | Yes                                 | Yes                               |
| **Java**     | No             | No                                  | No                                |
| **JS/TS**    | No             | Yes                                 | Yes                               |
| **Kotlin**   | Yes            | Yes                                 | Yes                               |
| **Lisp**     | Yes            | No                                  | No                                |
| **PHP**      | No             | No                                  | No                                |
| **Prolog**   | No             | No                                  | No                                |
| **Python**   | Yes            | Yes                                 | Yes                               |
| **Ruby**     | Yes            | No                                  | No                                |
| **Rust**     | Yes            | Yes                                 | Yes                               |
| **V**        | Yes*           | No                                  | Yes                               |
| **Zig**      | No             | Yes                                 | No                                |


## Error handling

|try/catch/throw|Result type

## Null and Type safety

Null safety means that the compiler can guarantee that a variable is not null.
I consider a language null safe even if it only has an opt-in null safety feature.

| **Language** | **Typing** | **Raw Pointers** | **Null/Nil Safety** | **Option\<T\> type** |
| ------------ | ---------- | ---------------- | ------------------- | -------------------- |
| **C**        | Static     | Yes              | No                  | No                   |
| **C#**       | Static     | Yes              | Yes                 | Yes                  |
| **C++**      | Static     | Yes              | No                  | Yes                  |
| **Clojure**  | Dynamic    | No               | No                  | No                   |
| **Elixir**   | Dynamic    | No               | No                  | No                   |
| **Go**       | Static     | No               | No                  | Yes                  |
| **Haskell**  | Static     | No               | Yes                 | No                   |
| **Java**     | Static     | No               | No*                 | Yes                  |
| **JS**       | Dynamic    | No               | No                  | No                   |
| **TS**       | Static     | No               | Yes*                | No                   |
| **Kotlin**   | Static     | No               | Yes                 | Yes*                 |
| **Lisp**     | Dynamic    | No               | No                  | No                   |
| **PHP**      | Dynamic    | No               | Yes                 | No                   |
| **Prolog**   | Dynamic    | No               | Yes                 | No                   |
| **Python**   | Dynamic    | No               | No                  | No                   |
| **Ruby**     | Dynamic    | No               | No                  | No                   |
| **Rust**     | Static     | Yes              | Yes                 | Yes                  |
| **V**        | Static     | Yes              | Yes                 | Yes                  |
| **Zig**      | Static     | Yes              | Yes                 | Yes                  |

## Memory management

|GC|Manual|Custom allocators|Heap only|

## Atomicity & Consistency

|Borrow checker|Ownership|Mutability by default|Thread safety|

## Modules & Encapsulation

|Modules|Encapsulation|Namespaces|

## Syntactic sugar

|Null coalescence/Optional chaining|operator overloading|function overloading|lambdas|generics|pattern matching|
C
C#
C++
Clojure
Elixir
Go
Haskell
Java
JS
Kotlin
Lisp
PHP
Prolog
Python
Ruby
Rust
V
Zig

| **Language**   | **Modular encapsulation** | **Member access**        | **Garbage Collector** |
| -------------- | ------------------------- | ------------------------ | --------------------- |
| **Java**       | Public/Private/Protected  |                          | Yes                   |
| **JavaScript** | Public/Private            |                          | Yes                   |
| **TypeScript** | Public/Private/Protected  |                          | No                    |
| **PHP**        | Public Only               |                          | Yes                   |
| **Prolog**     | N/A                       |                          | No                    |
| **Python**     | Public Only               |                          | Yes                   |
| **Ruby**       | Public Only               |                          | Yes                   |
| **Rust**       | Public Only               |                          | No                    |
| **V**          | Public Only               |                          | No                    |
| **Zig**        | Public Only               |                          | No                    |
| **Language**   | **Modular encapsulation** | **Member access**        | **Garbage collector** | **Generators** | **Pattern matching** | **try/catch/throw** |
| **C**          | Yes                       | Public                   | No                    | No             | No                   | Yes                 |
| **C#**         | Yes                       | Public/Private/Protected | Yes                   | Yes            | Yes*                 | Yes                 |
| **C++**        | Yes                       | Public/Private/Protected | Optional*             | Yes (20+)      | No                   | Yes                 |
| **Elixir**     | Yes                       | Public                   | Yes                   | No             | Yes                  | Yes                 |
| **Go**         | Yes                       |                          | Yes                   | No             | No                   | No                  |
| **Haskell**    | Yes                       |                          | Yes                   | No             | Yes                  | Yes                 |
| **Java**       | Yes                       |                          | Yes                   | No             | Yes                  | Yes                 |
| **JavaScript** | Yes                       |                          | Yes                   | Yes            | Yes                  | Yes                 |
| **Kotlin**     | Yes                       |                          | Yes                   | Yes            | Yes*                 | Yes                 |
| **Lisp**       | No                        |                          | Yes                   | Yes            | Yes                  | Yes                 |
| **Prolog**     | Yes                       |                          | Yes                   | No             | Yes                  | Yes                 |
| **Python**     | Yes                       |                          | Yes                   | Yes            | Yes                  | Yes                 |
| **Ruby**       | Yes                       |                          | Yes                   | Yes            | Yes                  | Yes                 |
| **Rust**       | Yes                       |                          | No                    | No             | Yes                  | Yes                 |
| **TypeScript** | Yes                       |                          | Yes                   | Yes            | Yes                  | Yes                 |
| **V**          | Yes                       |                          | No                    | Yes            | Yes                  | Yes                 |
| **Zig**        | Yes                       |                          | No                    | No             | Yes                  | Yes                 |