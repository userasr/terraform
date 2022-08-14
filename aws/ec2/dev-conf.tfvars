env                             = "Dev"   # Environment Dev or QA
team                            = "ACP"
project                         = "Data-Advocate"  #Project/team for this instance is getting created
technology                      = "airflow"   # technology running on this instance example superset, druid, docker
app_id                          = "2522"
cost_center                     = "30128"
system_manager_param_store_name = "/nimbus/gold/linux/centos-7"
Patch_Group                     = "analytics-dev-centos"
instance_type                   = "t2.micro"
instance_count                  = 1
public_ip                       = false
termination_protection          = false
iam_role                        = "Analytics-Instance"
subnet_id                       = "subnet-XXXXX"
security_groups		        = ["sg-XXXX"]
key_name                        = "anrathore"
#Root Volume Details
root_volume_size                   = 20
root_volume_type                   = "gp2"
root_volume_termination_protection = false
#Data Volume Details
create_data_volume = false
data_volume_size   = 30
data_volume_type   = "gp2"
#Log Volume Details
create_log_volume = false
log_volume_size   = 10
log_volume_type   = "gp2"
