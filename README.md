![Hypokorisma](https://repository-images.githubusercontent.com/185875759/e80e4380-86f1-11e9-801e-c6f4f96b0e67)

# Hypokorisma [![CircleCI](https://circleci.com/gh/aptdeco/hypokorisma/tree/master.svg?style=svg&circle-token=5efdcce6e51f019adf43caeaf11169d61fbde4b3)](https://circleci.com/gh/aptdeco/hypokorisma/tree/master)

> ### ὑποκόρισμα
>
> a diminutive form of a name.

## Main Features

- URL Shortening
- Visitor Counting
- Expirable Links
- URL deletion
- Multiple authorization strategies:
  - Local authorization via OAuth 2.0 (Google, GitHub, Microsoft, and Okta)
  - Proxy authorization for running behind e.g. [Google IAP](https://cloud.google.com/iap/)
- Dockerizable
- Multiple supported storage backends
  - High performance local database with [bolt](https://github.com/boltdb/bolt)
  - Persistent non-local storage with [redis](https://redis.io/)
