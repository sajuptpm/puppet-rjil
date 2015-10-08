set -xe

BUILD_TAG=_dev_test

##Export old token like this, to add new node to old cluster OR delete a node and add agin to same cluster.
#export consul_discovery_token=ace4af61b3ac4946ab3ac446434a37f2


###
export KEY_NAME=mykey1
export env_file=$(pwd)/openrc
export ssh_user=ubuntu
#export override_repo="http://jiocloud.rustedhalo.com:8080/job/pkg-test-build-comprehensive/25/artifact/new_repo.tgz"
export dns_server=10.140.192.34
export env_http_proxy=http://${dns_server}:3128/
export env_https_proxy=http://${dns_server}:3128/

###
export module_git_cache=http://jiocloud.rustedhalo.com:8080/job/puppet-jiocloud-cache/lastSuccessfulBuild/artifact/cache.tar.gz
export git_protocol=https

###
export BUILD_NUMBER=$BUILD_TAG

###
##Layout contains number of nodes and its flavor, image, disksize, network, secgroup, floatingip, etc---
##point to puppet-rjil/environment/full.yaml layout
export layout=nwdevlayout

###
##puppet-rjil/hiera/hiera.yaml contrail settings for hiera override hierarchies
##We can create /etc/puppet/hiera/data/secrets/{env}.yaml to override /etc/puppet/hiera/data/secrets/common.yaml
##We can create /etc/puppet/hiera/data/env/{env}.yaml to override /etc/puppet/hiera/data/common.yaml
export env=nwdevenv

###
##default value of cloud_provider will set to value of "env", if it not exported.
##location /etc/puppet/hiera/data/cloud_provider/{cloud_provider}.yaml
##puppet-rjil/build_scripts/common.sh uses it to create mappings_arg and that is used by jiocloud.apply_resources of puppet-rjil/build_scripts/deploy.sh
export cloud_provider=nwdevprovider

###
##ensure that the correct pull request number and repo are set
#export puppet_modules_source_repo=https://github.com/jiocloud/puppet-rjil
export puppet_modules_source_repo=https://github.com/sajuptpm/puppet-rjil
export puppet_modules_source_branch=contrailv2-vpram

./build_scripts/deploy.sh
#./build_scripts/test.sh


###jiocloud.apply_resources nwdevtest example###
###First change "puppet_modules_source_repo" and "puppet_modules_source_branch" if you want.
###Then run "./build_scripts/deploy.sh", I added an exit in ./build_scripts/deploy.sh, this will create a userdata.txt file.
###Then run command below "jiocloud.apply_resources apply"
#CMD:
#python -m jiocloud.apply_resources apply --key_name=mykey1 --project_tag=test_dev_test --mappings=environment/nwdevprovider.map.yaml environment/nwdevlayout.yaml userdata.txt


###Setting user password when launching cloud images###
###Add following 4 lines in userdata.txt file which created by ./build_scripts/deploy.sh, then run "jiocloud.apply_resources apply"
##cloud-config
#password: mypasswd
#chpasswd: { expire: False }
#ssh_pwauth: True


###Delete VMs###
#source venv/bin/activate
#CMD:
#python -m jiocloud.apply_resources delete test_dev_test


