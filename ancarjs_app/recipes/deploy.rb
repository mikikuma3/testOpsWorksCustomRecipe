include_recipe 'deploy'

Chef::Log.info("ancarjs_app::deploy start. JSON is #{node[:deploy]}")

node[:deploy].each do |application, deploy|

  # SKIP not target apps
  if deploy[:application] != 'ancarjs'
    Chef::Log.info("Skipping ancarjs_app::deploy. #{application} as it is not a ancarJS app")
    next
  end
  
  Chef::Log.info("Start ancarjs_app::deploy.")
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  current_dir = ::File.join(deploy[:deploy_to], 'current')

  ruby_block "build ancarjs_app" do
    block do
      cmd = "npm install -g bower gulp"
      Chef::Log.info("package.json detected. Running npm #{cmd}.")
      Chef::Log.info(OpsWorks::ShellOut.shellout("#{cmd} 2>&1"))
      
      cmd = "sudo su - #{deploy[:user]} -c 'cd #{current_dir} && npm install && bower install && gulp build'"
      Chef::Log.info("package.json detected. Running npm #{cmd}.")
      Chef::Log.info(OpsWorks::ShellOut.shellout("#{cmd} 2>&1"))
    end
  end
  
  Chef::Log.info("End loop ancarjs_app::deploy.")
end

Chef::Log.info("End ancarjs_app::deploy.")

