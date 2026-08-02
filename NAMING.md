# Naming convention — namespace & ServiceAccounts

Decided Sunday (Lab 01, Michael), needed by Eli for IRSA trust policies.

- **Namespace:** `sports-store` (fixed by the starter repo's `k8s/README.md` — every
  later stage assumes this name, don't change it).
- **ServiceAccount name = service name**, one per backend service:
  - `auth-service`
  - `catalog-service`
  - `cart-service`
  - `order-service`
  - `payment-service`
  - `gateway` (no DynamoDB access, but still gets its own SA for consistency / future IRSA-scoped needs e.g. ALB)

Each ServiceAccount will be annotated:

```yaml
eks.amazonaws.com/role-arn: <IRSA role ARN for that service>
```

So Eli's IRSA trust policy per service should trust:
`system:serviceaccount:sports-store:<service-name>`
