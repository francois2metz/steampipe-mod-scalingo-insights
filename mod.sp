mod "scalingo_insights" {
  title       = "Scalingo Insights"
  description = "Create dashboards and reports for your Scalingo resources using Steampipe."

  requires {
    plugin "francois2metz/scalingo" {
      version = "0.1.0"
    }
  }
}
