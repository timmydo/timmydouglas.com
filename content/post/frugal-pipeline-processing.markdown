---
date: 2021-10-05
tags:
- CPS
- continuation passing style
- caller
- memory
title: "Frugal pipeline processing"
---

Recently I was writing some code and I came across a scenario where I
wanted to chain together a log reader/transformer/sink pipeline. Here
is a simplified example:

```
interface transformer {
	list<item> process(list<item> items)
}


void work(void) {
	itemsToProcess = read()

	foreach (transformer in transformers) {
		tmp = transformer.process(itemsToProcess)
		free(itemsToProcess)
		itemsToProcess = tmp
	}
	
	write(itemsToProcess)
	free(itemsToProcess)
}
```

The problem with this approach is with memory management. In languages
with garbage collection, the wastefulness can be subtle--there are no
calls to free() to look out for, and it's uncommon for garbage
collected code to require disposal of regular objects. This makes it
more difficult to use things like pooled or preallocated memory. This
can be solved using a pattern similar to [continuation passing
style](https://en.wikipedia.org/wiki/Continuation-passing_style). It's
not really CPS because execution returns to the method, but it just
made me think of it.

Here is another way to write it:

```
interface step {
	void process(list<item> items, list<interface step> steps)
}

void step::process(input, steps) {
	processedItems = doWork(input)
	if len(steps) > 0 {
		steps[0].process(processedItems, steps[1..]])
	}
	free(processedItems)
}

void work(void) {
	steps = [reader] + transformers + [writer]
	steps[0].process([], steps[1..])
}
```

Ultimately, it's almost the same code--the difference is who is
freeing the processed items and how long they live. In the first
example, the `read()` items will be cleaned up after the first
transformer, while in the second, they will last until the end. If you
design a pipeline that wants to use a static pre-allocated buffer for
reading and have all the successive steps point back into slices of
that, the second design makes that easier.

In retrospective, it's not really that interesting of a problem if you
are used to programming in languages without garbage collection. But
when you write software in languages with garbage collection all day,
it's easier to design something that isn't frugal. 
