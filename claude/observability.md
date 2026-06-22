# Observability

## Observability review after every implementation

After completing an implementation, review whether its observability is sufficient — **without
over-dimensioning it**. This is a prompt, not an automatic action: surface any gap to me and
suggest how to close it, and explicitly call out where adding instrumentation would be excessive.

Check the three signals:

- **Logging** — is there enough structured logging to:
  1. **identify the process/flow** — which entity and component is acting (e.g. `user_id`, call id,
     `worker_name`, request id); and
  2. **see the outcome of each step** — success/failure, which branch was taken, the relevant result.

  Avoid the opposite failure too: don't log hot paths on every iteration when an upstream event
  already logs the flow.

- **Metrics** — are the metrics needed to monitor this behavior being emitted? But do **not**
  duplicate what logs or traces already expose; a metric that restates an existing log/trace is
  noise. Prefer an existing signal (e.g. an error/rejection log trend) over a new custom metric.

- **Traces** — do the necessary APM spans exist? Lean on auto-instrumentation (HTTP handlers,
  background jobs, DB/Redis clients) before adding manual spans.

### The bar

Enough information to **identify the process and observe its result** — no more. When in doubt,
ask whether a new signal would tell us something the existing logs/traces/metrics don't. If it
wouldn't, adding it is over-dimensioning.
