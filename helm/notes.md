### Repositories ###
bitnami         https://charts.bitnami.com/bitnami                  
puppet          https://puppetlabs.github.io/puppetserver-helm-chart
hashicorp       https://helm.releases.hashicorp.com  

to create a helm chart and its directory structure
`helm create nginx-chart`

to check the formatting failures
`helm lint ./chart-name`

to check template is generate correct values
`helm template <args> ./char-name`

* use --debug command to see the cause of the failure

to catch the kubernetes related issue use the --dry-run

functions

coalesce function takes a list of values and returns the first non-empty one.


