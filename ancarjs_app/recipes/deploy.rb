# Copyright 2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not
# use this file except in compliance with the License. A copy of the License is
# located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions
# and limitations under the License.

include_recipe 'deploy'

Chef::Log.info("ancarjs_app::deploy start. JSON is #{node[:deploy]}")

node[:deploy].each do |application, deploy|

  # SKIP not target apps
  if deploy[:application] != 'ancarjs'
    Chef::Log.info("Skipping ancarjs_app::deploy. #{application} as it is not a ancarJS app")
    next
  end
  
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

  cmd = "npm install -g bower gulp"
  Chef::Log.info("package.json detected. Running npm #{cmd}.")
  Chef::Log.info(OpsWorks::ShellOut.shellout("#{cmd} 2>&1"))
  
  cmd = "sudo su - #{node[:opsworks][:deploy_user][:user]} -c 'cd #{current_dir} && npm install && bower install && gulp build'"
  Chef::Log.info("package.json detected. Running npm #{cmd}.")
  Chef::Log.info(OpsWorks::ShellOut.shellout("#{cmd} 2>&1"))
  
  
#  webapp_dir = ::File.join(node['tomcat']['webapps_base_dir'], deploy[:document_root].blank? ? application : deploy[:document_root])

  # opsworks_deploy creates some stub dirs, which are not needed for typical webapps
#  ruby_block "remove unnecessary directory entries in #{current_dir}" do
#    block do
#      node['tomcat']['webapps_dir_entries_to_delete'].each do |dir_entry|
#        ::FileUtils.rm_rf(::File.join(current_dir, dir_entry), :secure => true)
#      end
#    end
#  end

#  link webapp_dir do
#    to current_dir
#    action :create
#  end

#  include_recipe 'tomcat::service'

#  execute 'trigger tomcat service restart' do
#    command '/bin/true'
#    not_if { node['tomcat']['auto_deploy'].to_s == 'true' }
#    notifies :restart, resources(:service => 'tomcat')
#  end
end
