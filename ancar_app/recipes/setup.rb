
# dependencie OS package setting
ancar_os_pkgs = ['postgresql94-devel', 'postgresql94-libs', 'ImageMagick-devel', 'nodejs-devel']

# install OS packages
ancar_os_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

# 不具合回避。初回bundle install 時に SystemStackError: stack level too deep が発生する
ruby_block "gem upate" do
  block do
    cmd = "gem update --no-ri --no-rdoc"
    Chef::Log.info("Do cmd. #{cmd}")
    Chef::Log.info(OpsWorks::ShellOut.shellout("#{cmd} 2>&1"))
  end
end
