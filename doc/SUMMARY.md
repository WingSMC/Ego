# Summary

## HU

Az "Ego" projekt célja egy minimalista és gyors programozási nyelv készítése, ami több programozási paradigma használatát is lehetővé teszi a programozó számára, ugyanakkor jobban behatárolja projektszervezést és a kódolás több aspektusát, hogy könnyebb legyen a programozónak kódbázisok között mozogni.

A szintaxist és a nyelvi elemeket főleg a C#, C++, Kotlin, Rust, Go, JavaScript, Python és Elixir nyelvek inspirálták. A C++-nál sokkal jobban elmegy funkcionális irányokba, például C++-ban a "const" kulcsszó használatával teszünk egy értéket konstanssá, itt az immutabilitás az alapértelmezett. A lambda kifejezések, touple-ök és minta illesztés használata javasolt, de a funkcionális elemek teljesen opcionálisak, mert minden kényelem ellenére ezek árthatnak is a teljesítménynek.

A nyelvben a C/C++/Rust-ból ismert dinamikus memória kezelés használatos pointerekkel. Ezen felül olyan alacsonyabb szintű operációk is nagy prioritást kapnak, mint a kényelmes bit, byte és logikai érték manipulációk.

A távoli célok között van többek között a memória biztonság, a többszálúság kényelmes és biztonságos kezelése és a beépített teszt támogatás.

## EN

The aim of the "Ego" project is to create a minimalist, opinionated and fast programming language that enables the use of multiple programming paradigms, while better defining project organization and various aspects of coding, making it easier for programmers to navigate between codebases.

The syntax and language features are mainly inspired by the C#, C++, Kotlin, Rust, Go, JavaScript, Python, and Elixir languages. It leans heavily towards functional programming, for instance, in C++, "const" must be written before a variable to prevent it from being changed, while here immutability is the default. The use of clojoures, touples, and pattern matching is encouraged, but most functional features are not forced onto the programmer, as they may harm performance despite their convenience.

The language uses dynamic memory management similar to C/C++/Rust with pointers. In addition, lower-level operations such as comfortable bit, byte, and logical value manipulation are given high priority.

The long term (out of current scope) goals include memory safety, comfortable and secure management of multithreading, and native testing support.
