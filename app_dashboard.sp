dashboard "scalingo_app_dashboard" {
  title = "Scalingo App Dashboard"

  input "app_name" {
    title = "Application name"
    width = 2

    sql  = <<-EOQ
    select
      name as label,
      name as value
    from
      scalingo_app;
  EOQ
  }

  container {
    table {
      title = "Containers"
      query = query.scalingo_app_containers
      width = 6

      args  = {
        app_name = self.input.app_name.value
      }
    }

    table {
      title = "Addons"
      query = query.scalingo_app_addons
      width = 6

      args  = {
        app_name = self.input.app_name.value
      }
    }

    table {
      title = "Activity"
      query = query.scalingo_app_events
      width = 6

      args  = {
        app_name = self.input.app_name.value
      }
    }
  }
}

query "scalingo_app_containers" {
  sql = <<-EOQ
    select
      name as "Name",
      amount as "Amount",
      command as "Command",
      size as "Size"
    from
      scalingo_container
    where
     app_name = $1;
  EOQ


  param "app_name" {}
}

query "scalingo_app_addons" {
  sql = <<-EOQ
    select
      provider_name as "Name",
      status as "Status",
      plan_display_name as "Plan"
    from
      scalingo_addon
    where
     app_name = $1;
  EOQ


  param "app_name" {}
}


query "scalingo_app_events" {
  sql = <<-EOQ
    select
      created_at as "Date",
      type as "Type",
      user_username as "User"
    from
      scalingo_app_event
    where
     app_name = $1
    order by
      created_at desc
    limit
      20;
  EOQ


  param "app_name" {}
}
