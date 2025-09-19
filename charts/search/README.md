# Search Tool Helm Chart

This Helm chart deploys a search tool consisting of multiple services, including a crawler and flaresolverr, on a Kubernetes cluster. It provides a convenient way to manage the deployment and configuration of these services.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.x

## Installation

To install the chart, use the following command:

```bash
helm install <release-name> ./search-helm-chart
```

Replace `<release-name>` with your desired release name.

## Configuration

The following table lists the configurable parameters of the chart and their default values:

| Parameter                     | Description                                      | Default                |
|-------------------------------|--------------------------------------------------|------------------------|
| `image.repository`            | Image repository for the crawler and flaresolverr | `your-image-repo`      |
| `image.tag`                   | Image tag for the crawler and flaresolverr      | `latest`               |
| `service.type`                | Service type (ClusterIP, NodePort, LoadBalancer) | `ClusterIP`            |
| `service.port`                | Port for the service                             | `80`                   |
| `env`                         | Environment variables for the containers         | `{}`                   |

## Usage

After installation, you can access the services using the service endpoints. If you have configured ingress, you can access them via the specified hostnames.

## Uninstallation

To uninstall the chart, use the following command:

```bash
helm uninstall <release-name>
```

## Notes

- Ensure that your Kubernetes cluster has sufficient resources to run the services.
- For more advanced configurations, refer to the `values.yaml` file.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
