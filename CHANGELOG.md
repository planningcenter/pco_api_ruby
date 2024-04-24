# 2.1.1 (April 24, 2024)

- Fix: Tell Faraday to use JSON for the request

# 2.1.0 (April 14, 2023)

- Chore: Use 2.x version of Faraday

# 2.0.2 (January 10, 2023)

- Fix: fix bug handling 204 No Content responses

# 2.0.1 (August 8, 2022)

- Chore: update Faraday dependency and update Faraday auth setup

# 2.0.0 (March 1, 2021)

- Feature: automatically retry when rate limited

# 1.3.1 (March 1, 2021)

- Fix: argument passing for keyword args in Ruby 3

# 1.3.0 (September 21, 2020)

* Feature: add TooManyRequests (429) error class
* Feature: expose headers as attr on response and on error class
* Chore: bump version of Excon

# 1.2.2 (August 17, 2017)

* Chore: fix Faraday middleware warning

# 1.2.1 (November 18, 2016)

* Chore: bump Faraday dependency versions and loosen specificity

# 1.2.0 (November 23, 2015)

* Improvement: improve exception `message` and add `detail` method for raw response

# 1.1.2 (June 8, 2015)

* Fix: fix "break from proc-closure (LocalJumpError)" error by upgrading Excon

# 1.1.1 (June 5, 2015)

* Fix: always return a string for error.message

# 1.1.0 (June 5, 2015)

* Fix: use url-encoded body for oauth endpoints
* Feature: improve exceptions for different status codes

# 1.0.0 (June 3, 2015)

Initial release.
