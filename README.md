# Scalingo insights

A Scalingo dashboarding tool that can be used to view dashboards and reports across all of your Scalingo accounts.

## Getting started

### Installation

1) Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```shell
brew tap turbot/tap
brew install steampipe

steampipe -v
steampipe version 0.13.0
```

2) Install the Scalingo plugin:

```shell
steampipe plugin install francois2metz/scalingo
```

3) Clone this repo:

```sh
git clone https://github.com/francois2metz/steampipe-mod-scalingo-insights.git
cd steampipe-mod-scalingo-insights
```

### Usage

Start your dashboard server to get started:

```shell
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser window at https://localhost:9194.

From here, you can view all of your dashboards and reports.
