# remove ruby 2.5/rake if installed
apt purge libruby ruby rake

# add repositories for xenial and xenial-updates
cat << EOF > /etc/apt/sources.list.d/xenial.list
deb http://archive.ubuntu.com/ubuntu/ xenial main
deb http://archive.ubuntu.com/ubuntu/ xenial-updates main
EOF

# priorise ruby/rake from xenial repository
cat << EOF > /etc/apt/preferences.d/ruby-xenial
Package: ruby
Pin: release v=16.04, l=Ubuntu
Pin-Priority: 1024

Package: rake
Pin: release v=16.04, l=Ubuntu
Pin-Priority: 1024
EOF

# install ruby and dependent packages
apt update
apt install ruby gdebi-core

# download and run codedeploy-agent installer
curl -o /tmp/codedeploy-installer https://aws-codedeploy-eu-west-1.s3.amazonaws.com/latest/install
chmod +x /tmp/codedeploy-installer
/tmp/codedeploy-installer auto

# delete installer script
rm -f /tmp/codedeploy-installer

# create systemd service file and enable it
mv /etc/init.d/codedeploy-agent.service /lib/systemd/system/codedeploy-agent.service
systemctl enable codedeploy-agent.service
