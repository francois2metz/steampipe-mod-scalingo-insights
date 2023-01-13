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

      column "Name" {
        href = "${dashboard.scalingo_app_dashboard.url_path}?input.app_name={{.'Name' | @uri}}"
      }
    }

    graph {
      title = "Infrastructure"

      node {
        category = category.region

        sql = <<-EOQ
          select
            name as id,
            display_name as title
          from
            scalingo_region
        EOQ
      }

      node {
        category = category.app

        sql = <<-EOQ
          select
            id,
            name as title
          from
            scalingo_app
        EOQ
      }

      node {
        category = category.addon

        sql = <<-EOQ
          select
            scalingo_addon.id,
            scalingo_addon.provider_name as title
          from
            scalingo_addon
          join
            scalingo_app
          on
            scalingo_addon.app_name = scalingo_app.name;
        EOQ
      }

      edge {
        sql = <<-EOQ
          select
            region as from_id,
            id as to_id
          from
            scalingo_app
        EOQ
      }

      edge {
        title = "App - Addon"

        sql = <<-EOQ
          select
            scalingo_addon.id as to_id,
            scalingo_addon.app_id as from_id
          from
            scalingo_addon
          join
            scalingo_app
          on
            scalingo_addon.app_name = scalingo_app.name;
        EOQ
      }
    }
  }
}

category "region" {
  title = "Regions"
  icon  = "heroicons-outline:building-office"
  color = "green"
}

category "app" {
  title = "App"
  icon  = "inventory_2"
  color = "blue"
}

category "addon" {
  title = "Addon"
  icon  = "database"
  color = "red"
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
      sum(scalingo_container_type.amount) as "Containers"
    from
      scalingo_container_type
    join
      scalingo_app
    on
      scalingo_container_type.app_name = scalingo_app.name;
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
