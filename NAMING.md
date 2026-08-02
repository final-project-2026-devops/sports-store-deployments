# Naming convention — namespace & ServiceAccounts

Decided Sunday (Lab 01, Michael), needed by Eli for IRSA trust policies.

**Updated same day** after checking `sports-store-Terraform/sports-store-infrastructure` —
the IRSA trust policies in `dynamodb.tf` were already written against a specific
namespace/SA pattern, so the convention below matches what's actually deployed rather than
what was originally proposed.

- **Namespace:** `sports-store` (fixed by the starter repo's `k8s/README.md` — every later
  stage assumes this name, don't change it).
  - ⚠️ `sports-store-infrastructure`'s `k8s_namespace` variable currently **defaults to
    `cloudcart`**, not `sports-store`. **Action for Eli:** override it to `sports-store` via
    `terraform.tfvars` (or the Terraform Cloud workspace variable) before applying — this is a
    one-line variable change, cheaper than changing the namespace everywhere else.
- **ServiceAccount name = `<service>-service-sa`**, one per backend service — this exact
  pattern is hardcoded in `dynamodb.tf`'s `namespace_service_accounts` on the
  `dynamodb_service_irsa_role` module (not just a variable), so the chart matches Terraform
  rather than the other way around:
  - `auth-service-sa`
  - `catalog-service-sa`
  - `cart-service-sa`
  - `order-service-sa`
  - `payment-service-sa`
  - `gateway-sa` (no DynamoDB access / no Terraform-side role today, but kept in the same
    pattern for consistency)

Each ServiceAccount will be annotated:

```yaml
eks.amazonaws.com/role-arn: <IRSA role ARN for that service>
```

So Eli's IRSA trust policy per service should trust (once the namespace override above lands):
`system:serviceaccount:sports-store:<service>-service-sa`
