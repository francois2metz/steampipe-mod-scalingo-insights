dashboard "scalingo_app_dashboard" {
  title = "Scalingo App Dashboard"

  container {
    card {
      sql   = query.scalingo_app_count.sql
      width = 2
    }
    card {
      sql   = query.scalingo_app_container.sql
      width = 2
    }
    card {
      sql   = query.scalingo_addon_count.sql
      width = 2
    }
    card {
      sql   = query.scalingo_collaborator_count.sql
      width = 2
    }
  }

  container {
    chart {
      title = "Regions"
      sql   = query.scalingo_app_by_region.sql
      type  = "pie"
      width = 2
    }
  }
}

query "scalingo_app_count" {
  sql = <<-EOQ
    select
      count(*) as "Apps"
    from
      scalingo_app;
  EOQ
}

query "scalingo_app_container" {
  sql = <<-EOQ
    select
      sum(scalingo_container.amount) as "Containers"
    from
      scalingo_container
    join
      scalingo_app
    on
      scalingo_container.app_name = scalingo_app.name;
  EOQ
}

query "scalingo_addon_count" {
  sql = <<-EOQ
    select
      count(*) as "Addons"
    from
      scalingo_addon
    join
      scalingo_app
    on
      scalingo_addon.app_name = scalingo_app.name;
  EOQ
}

query "scalingo_app_by_region" {
  sql = <<-EOQ
    select
      region as "Region",
      count(*) as "App"
    from
      scalingo_app
    group by
      region;
  EOQ
}

query "scalingo_collaborator_count" {
  sql = <<-EOQ
    select
      count(distinct(scalingo_collaborator.user_id)) as "Collaborators"
    from
      scalingo_collaborator
    join
      scalingo_app
    on
      scalingo_app.name = scalingo_collaborator.app_name;
  EOQ
}
