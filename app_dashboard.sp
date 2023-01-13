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
    card {
      query = query.scalingo_app_region
      width = 3
      icon = "heroicons-outline:building-office"

      args  = {
        app_name = self.input.app_name.value
      }
    }

    card {
      query = query.scalingo_app_containers_count
      width = 2
      icon = "heroicons-outline:server"

      args  = {
        app_name = self.input.app_name.value
      }
    }

    card {
      query = query.scalingo_app_collaborators_count
      width = 2
      icon = "person"

      args  = {
        app_name = self.input.app_name.value
      }
    }
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
      title = "Environment"
      query = query.scalingo_app_environment
      width = 6

      args  = {
        app_name = self.input.app_name.value
      }
    }

    table {
      title = "Collaborators"
      query = query.scalingo_app_collaborators
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

query "scalingo_app_region" {
  sql = <<-EOQ
    select
      region as "Region"
    from
      scalingo_app
    where
     name = $1;
  EOQ

  param "app_name" {}
}

query "scalingo_app_containers" {
  sql = <<-EOQ
    select
      name as "Name",
      amount as "Amount",
      command as "Command",
      size as "Size"
    from
      scalingo_container_type
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
    limit
      20;
  EOQ

  param "app_name" {}
}

query "scalingo_app_collaborators" {
  sql = <<-EOQ
    select
      username as "Username",
      email as "Email",
      status as "Status"
    from
      scalingo_collaborator
    where
      app_name = $1;
  EOQ

  param "app_name" {}
}

query "scalingo_app_environment" {
  sql = <<-EOQ
    select
      name
    from
      scalingo_environment
    where
      app_name = $1;
  EOQ

  param "app_name" {}
}

query "scalingo_app_containers_count" {
  sql = <<-EOQ
    select
      sum(amount) as "Containers"
    from
      scalingo_container_type
    where
     app_name = $1;
  EOQ

  param "app_name" {}
}

query "scalingo_app_collaborators_count" {
  sql = <<-EOQ
    select
      count(*) as "Collaborators"
    from
      scalingo_collaborator
    where
      app_name = $1;
  EOQ

  param "app_name" {}
}
