
# dependencie OS package setting
ancar_os_pkgs = ['postgresql94-devel', 'postgresql94-libs', 'ImageMagick-devel', 'nodejs-devel']

# install OS packages
ancar_os_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end
