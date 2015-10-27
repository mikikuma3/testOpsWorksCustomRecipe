
# dependencie OS package setting
ancarjs_os_pkgs = ['nodejs', 'npm']

# install OS packages
ancarjs_os_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end
