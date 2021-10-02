# Map of instances' complete information
output "instances" {
  sensitive = true
  value = {
    for i, v in local.instances:
      i => merge(v, {
        user = data.template_file.user_data[i].vars.user
        password = data.template_file.user_data[i].vars.password
        hostname = data.template_file.user_data[i].vars.hostname
      })
  }
}