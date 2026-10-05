# Testing

## No statistics or volatile figures in test names

A test name must not carry a measurement that will drift: traffic shares, percentages of real
payloads, counts of producers, volumes per day. The figure was true the day it was measured and
becomes a lie afterwards, with nothing to catch it.

```ts
// ✗ — the percentage rots, and no test failure will ever tell you
it('should not report an anonymous callerNumber, which is 1.36% of real traffic', …)

// ✗ — the number is gone and so is the information; vague filler is not an improvement
it('should not report an anonymous callerNumber, which real traffic carries', …)

// ✓
it('should not report an anonymous callerNumber', …)
```

Delete the clause. Do not hollow the measurement out into something vaguer that survives — if what
remains does not name a cause, it is noise. Measurements belong in the MR description, the ticket or a
dashboard, where they are dated and can be re-run.

A trailing clause earns its place only when it names **why**, and a reader could not infer it:
`which livecall does not send` explains why a required-looking field may be absent. `which real
traffic carries` explains nothing.

This does **not** apply to a figure the code itself implements. `it('should send metrics when call
queue size is above 80% threshold')` is describing the behaviour under test, not a statistic.

Related: avoid naming a specific incident or a one-off production value in a fixture when any value of
that shape proves the same thing. `target.id: 'not-an-integer'` says what the schema rejects;
`target.id: '$REGIONAL_SM_GROUP'` ties the test to an outage nobody will remember.

## One property per test

When a test would assert two distinct properties, split it. A property hidden inside a test named
after a different property is a property nobody maintains.

Put the contrasting cases next to each other instead of merging them — "a conforming payload is not
altered" and "a coercible payload is coerced" are two tests, adjacent, not one.

## An assertion that cannot fail is not an assertion

Before trusting a new or edited test, falsify it: break the thing it claims to protect and confirm the
test goes red. Two failure modes to watch for:

- **Self-comparison.** If the function under test returns the same reference it was given, comparing
  the result with the input compares an object with itself and can never fail. Snapshot the input
  first (`structuredClone`) and compare against that.
- **Asserting the wrapper instead of the cause.** If a decorator rewraps every error into one type,
  asserting that type passes for any failure at all. Assert the `cause`.

## Minimise the test diff that an implementation change forces

When changing an implementation breaks its tests, the baseline is the **default branch**, not whatever
the working branch has accumulated. Start from the default branch's version of the test file and apply
only the edits the implementation change makes unavoidable: keep its structure, its fixtures, its
cases and its names.

Rewriting a test file into a shape I prefer, while adapting it, hides the real cost of the change and
makes the diff unreviewable. Change a test name only when the change makes it **false**.

## No test per schema particularity

A test that restates a schema or a type earns nothing. To check a particular, use a throwaway script
(`npx tsx`) instead of adding a permanent test.

Do fix tests whose premise the change disproves — that is not the same thing.

## Prefer generic test subjects

Name what the test establishes, not an enumeration of the specific values it happens to use. Several
specific values exercised by one loop still describe one rule.
