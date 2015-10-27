###
# ancarJSをOpsWorks上にデプロイする為のレシピです。
# ・opsworks上でapp(name=ancarJS)が作成されている必要があります。
# ・opsworks上のデプロイ対象layerのcustombookのdeployセクションに本ファイルを指定します
#
# 処理の流れ
# ・opsworksのappの流儀に従って、デプロイ先のフォルダを作成し、ソースコードをチェックアウトします
# ・AngularJSをビルドします
# 
###

include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  # SKIP not target apps
  if deploy[:application] != 'ancarjs'
    Chef::Log.info("Skipping ancarjs_app::deploy. #{application} as it is not a ancarJS app")
    next
  end
  
  # opsworks default deploy operation. make dir ...etc
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end
  
  # opsworks default deploy operation. checkout source code ...etc
  opsworks_deploy do
    deploy_data deploy
    app application
  end

  current_dir = ::File.join(deploy[:deploy_to], 'current')

  # build ancarjs. run npm install ...etc
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
  
end
