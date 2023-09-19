Infrastructure as code using terraform and terragrunt

How to deploy?

```sh
cd live
terragrunt run-all apply
```

To deploy a specific environment (e.g., staging)

```sh
cd live/staging
terragrunt run-all apply
```

Similar way you can keep going down the folder structure to deploy specific components as well.

References:

1. https://blog.gruntwork.io/how-to-manage-multiple-environments-with-terraform-using-terragrunt-2c3e32fc60a8
2. https://github.com/betarabbit/terraform-terragrunt-azure-example
