---
title: Learn weird programming languages
---
In 2001, [Paul Graham](https://www.paulgraham.com/index.html) defined what he calls ["The Blub Paradox"](https://paulgraham.com/avg.html). The basic concept is that a programmer who only knows "Language Blub" (a middle-ground programming language) looks down at lower-level languages and sees them as lacking features. However, when they look up at more powerful languages, they cannot see the benefits- they just see "weird syntax."<!--more--> The paradox is as relevant as ever. Think how many developers have never peeked above the Typescript fence. They learned a tool that works, it pays the bills, and the ecosystem is massive. It's comfortable and safe. Why would I struggle with something else?

The reason is that programming languages are not just tools but they shape the way you think about code. If you solve problems exclusively in the Blub language, your brain will only suggest Blub-shaped solutions. You will never be exposed to non-Blub ways of thinking which might actually apply better to your problem.

While a language might strictly enforce a paradigm, the *concepts* are often transferable. A great example of this is [Effect-ts](https://effect.website/) - a Typescript library directly inspired by Scala's [ZIO](https://zio.dev/). The authors brought a "foreign" mental model (functional effects) into a mainstream language, creating something powerful.

It kind of relates to the [Sapir-Whorf hypothesis](https://en.wikipedia.org/wiki/Linguistic_relativity). The hypothesis states that the language you speak influence your way of thinking and your worldview. In programming - every new language you learn gives you new mindset for solving problems. Your mind is 'reprogrammed' every time you try a language. <span class="text-body/30">
*(btw there's a cool move called [Arrival](https://www.imdb.com/title/tt2543164/) that explores Sapir-Whorf hypothesis)*
</span>


So, learn weird languages. Here is a short list of paradigm shifts worth your time:

- **Functional languages:** Try **OCaml** or **Haskell**. You will finally see what those "functional bros" are talking about when they obsess over immutability and side effects.
- **Actor model:** Try **Elixir** or **Erlang**. It forces you to think about concurrency not as "threads sharing memory", but as "independent processes sending messages".
- **The Machine:** Try **Assembly**. You get to learn what your favourite language is actually compiled to.
- **Array languages:** Try **APL**, **J**, or **BQN**. (I haven't gotten into these yet, but the concept is interesting: operating on entire datasets at once without writing a single loop).

**You don't have to become an expert in any of these.**

You don't need to put them on your resume. Just choose a simple task to do in every new programming language you learn. For example, do the first 3 days of Advent of Code, or create a simple JSON parser. I'm sure you can figure something out.

*A language that doesn't affect the way you think about programming, is not worth knowing.* ~ [Alan Perlis](https://www.cs.yale.edu/homes/perlis-alan/quotes.html)
