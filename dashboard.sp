dashboard "scalingo_dashboard" {
  title = "Scalingo Dashboard"

  container {
    card {
      sql   = query.scalingo_apps_count.sql
      width = 2
    }
    card {
      sql   = query.scalingo_apps_container.sql
      width = 2
    }
    card {
      sql   = query.scalingo_addons_count.sql
      width = 2
    }
    card {
      sql   = query.scalingo_collaborators_count.sql
      width = 2
    }
  }

  container {
    chart {
      title = "Regions"
      sql   = query.scalingo_apps_by_region.sql
      type  = "pie"
      width = 2
    }

    table {
      title = "Apps"
      sql   = query.scalingo_apps.sql

      column "name" {
        href = "${dashboard.scalingo_app_dashboard.url_path}?input.app_name={{.'name' | @uri}}"
      }
    }
  }
}

query "scalingo_apps_count" {
  sql = <<-EOQ
    select
      count(*) as "Apps"
    from
      scalingo_app;
  EOQ
}

query "scalingo_apps_container" {
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

query "scalingo_addons_count" {
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

query "scalingo_apps_by_region" {
  sql = <<-EOQ
    select
      region as "Region",
      count(*)
    from
      scalingo_app
    group by
      region;
  EOQ
}

query "scalingo_collaborators_count" {
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


query "scalingo_apps" {
  sql = <<-EOQ
    select
      name as "Name",
      region as "Region"
    from
      scalingo_app;
  EOQ
}
