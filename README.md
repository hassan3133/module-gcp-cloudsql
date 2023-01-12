# CloudSQL Module
![Maintained by Hassan-DevOps](https://img.shields.io/badge/maintained%20by-priceline.com-blue)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.13-blue.svg)

## Usage
Refer to the modules README.md files under modules directory for the complete usage details.

## MySQL
This module supports following types of mysql database.
- [Single instance, without HA](modules/mysql/README.md#single-instance-ha)
- [Single instance, with HA](modules/mysql/README.md#single-instance-non-ha)
- [Primary(master) instance with replicas in different zones and diffrent region, without HA](modules/mysql/README.md#primary-instance-with-replicas-ha).
- [Primary(master) instance with replicas in different zones and diffrent region, with HA](modules/mysql/README.md#primary-instance-with-replicas-non-ha).

**Note:** By default `binary_log_enabled` is true for standlone and primary(master) instance, to enable HA set `availability_type` to `REGIONAL`.

## PostgreSQL
This module supports following types of mysql database.
- [Single instance, without HA](modules/postgresql/README.md#single-instance-ha)
- [Single instance, with HA](modules/postgresql/README.md#single-instance-non-ha)
- [Primary(master) instance with replicas in different zones and diffrent region, without HA](modules/postgresql/README.md#primary-instance-with-replicas-ha).
- [Primary(master) instance with replicas in different zones and diffrent region, with HA](modules/postgresql/README.md#primary-instance-with-replicas-non-ha).

**Note:**
- By default `binary_log_enabled` is `false` for postgres instance, to enable HA set `availability_type` to `REGIONAL`.
- Postgres supports only shared-core machine types such as db-f1-micro, and custom machine types such as db-custom-2-13312
- To build custome machines see https://cloud.google.com/compute/docs/instances/creating-instance-with-custom-machine-type#create

## Found bug
If you found the bug contribute or reach out to the authors.

### Authors
- [Yevgeny Finkelshteyn][yf]
- [Gopinath Prabhu][gp]
- [John Brilla][jb]
- [Andrey Larin][al]

[yf]: mailto:yevgeny.finkelshteyn@priceline.com
[al]: mailto:andrey.larin@priceline.com
[gp]: mailto:gopinath.prabhu@priceline.com
[jb]: mailto:john.brilla@priceline.com
