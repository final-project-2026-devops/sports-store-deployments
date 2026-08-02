# `values.yaml` env-var schema

Published Monday (Lab 01, Michael) — the application code in each service repo needs to read
these exact variable names. Table names match what `sports-store-Terraform`'s `dynamodb.tf`
actually creates (one table per service), not the 6-table Users/Products/Variants/Carts/
Orders/Payments split described in `ROADMAP.md` — Terraform is the source of truth here since
it's the thing that actually provisions the table.

⚠️ **Known gap, flagged to Eli**: `sports-store-auth-service/database.py` currently hardcodes
`dynamodb.Table("Users")` instead of reading a table-name env var, and passes an explicit
`aws_access_key_id` fallback of `"local"` into `boto3.resource(...)` — which breaks IRSA (an
explicit credential kwarg wins over boto3's default credential chain, so if
`AWS_ACCESS_KEY_ID` isn't set in the pod, boto3 never even tries IRSA). See `LAB-ELI.md` for
detail. This schema is what the code *should* read once that's fixed.

## Non-secret (ConfigMap, one per service)

| Variable | Services | Value |
|---|---|---|
| `AWS_REGION` | all 5 backend services | `us-east-1` (matches Terraform) |
| `DYNAMODB_TABLE_NAME` | all 5 backend services | that service's own table: `auth-service-table`, `catalog-service-table`, `cart-service-table`, `order-service-table`, `payment-service-table` |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | auth-service | `60` |
| `CATALOG_URL` | cart-service, order-service | `http://catalog-service` (in-cluster Service DNS, same namespace) |
| `CART_URL` | order-service | `http://cart-service` |
| `PAYMENT_URL` | order-service | `http://payment-service` |
| `SHIPPING_FLAT_RATE` | order-service | business config, e.g. `5.99` |
| `FREE_SHIPPING_THRESHOLD` | order-service | business config, e.g. `50` |
| `PAYMENT_FAILURE_SUFFIX` | payment-service | business/demo config |

## Secret (shared `app-secrets`, one Secret, all 5 backend services)

| Variable | Notes |
|---|---|
| `JWT_SECRET` | same value across all 5 services — auth-service issues tokens, the other 4 verify them |

`gateway` gets neither — it doesn't touch DynamoDB or verify JWTs itself, it just proxies.

## Local dev vs. real cluster

`values.yaml`'s `secrets.jwtSecret` is a placeholder (`dev-secret-change-me`, matching
`sports-store-auth-service/.env.example`) for local `kind` testing only. **Never commit a real
JWT secret here** — the real value gets supplied at deploy time (`helm upgrade --set-string
secrets.jwtSecret=$JWT_SECRET`, sourced from a GitHub Actions secret or similar), same principle
as `k8s/README.md`'s existing Secret guidance.
