# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`pco_api` is a Ruby gem that wraps the Planning Center Online REST API (`api.planningcenteronline.com`). It uses `method_missing` to dynamically build endpoint URLs from chained method calls (e.g., `api.people.v2.households[1].get`), supporting HTTP Basic and OAuth2 authentication via Faraday with the Excon adapter.

## Commands

```bash
bundle install          # Install dependencies
bundle exec rspec       # Run all tests
bundle exec rspec spec/pco/api/endpoint_spec.rb          # Run a single spec file
bundle exec rspec spec/pco/api/endpoint_spec.rb:31       # Run a specific example by line number
bundle exec rspec -t focus                                # Run only focused specs (focus: true)
```

## Architecture

The gem has three core files under `lib/pco/api/`:

- **`endpoint.rb`** — The main class. `PCO::API.new` returns an `Endpoint`. Each chained method call or `[]` access creates a new `Endpoint` with an extended URL (cached in `@cache`). HTTP methods (`get`, `post`, `patch`, `delete`) execute requests via a shared Faraday `@connection`. Rate-limited responses (429) are automatically retried after sleeping for the `Retry-After` duration unless `retry_when_rate_limited` is set to false.
- **`errors.rb`** — Error hierarchy rooted at `PCO::API::Errors::BaseError`. Maps HTTP status codes to specific error classes. Errors expose `status`, `detail`, `headers`, and a `message` that summarizes validation errors when present.
- **`version.rb`** — Single `VERSION` constant.

`PCO::API::Response` is a `Hash` subclass with an added `headers` accessor, returned from all successful requests.

## Testing

Tests use RSpec with WebMock to stub HTTP requests. No real API calls are made. Specs are randomized by default.
