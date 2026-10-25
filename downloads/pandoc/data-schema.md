# Summary

|Data Group|Data Field Count|
|---|---|
|Cloud|23|
|Asset|43|
|Hardware|18|
|Data|12|
|Threat|14|
|Age|15|
|Vulnerability|11|
|User|30|
|Location|10|
|Risk|14|
|Data Source|5|
|Applications|14|
|Network|47|
|Others|14|
||1|
|Compliance|19|
|Tags|2|
|Policy|16|
|DevOps|2|
|LifeCycle|7|
|CAASM|2|

# Cloud
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|CloudTrail_Bucket|Cloud Trail Bucket|CloudTrail bucket name|String
|CloudTrail_LogGroup|Cloud Trail Log Group|CloudTrail log group|String
|CloudTrail_Name|Cloud Trail Name|CloudTrail name|String
|CloudTrail_Not_Log|CloudTrail Log (yes/no)|True if the asset is NOT logged in CloudTrail|Binary
|CloudTrail_Resource|Cloud Trail Resource|CloudTrail resource|String
|Cloud_Account_ID|Cloud Account ID|Cloud account ID(s)|undefined
|Cloud_Account_Name|Cloud Account|Cloud account name(s)|undefined
|Cloud_Stack_Name|Cloud Stack|Asset stack name|String
|Image_Create_Datetime|Image Creation Time|Instance image creation epoch time|Datetime
|Image_ID|Image ID|Instance image ID|String
|Image_Name|Image Name|Instance image name|String
|Instance_Profile|Instance Profile|Cloud instance’s profile/role|String
|Is_CloudTrail_GlobalService|Cloud Trail Global-Service (yes/no)|True if CloudTrail includes API calls from global services|Binary
|Is_CloudTrail_Log|CloudTrail Log (yes/no)|True if the asset is logged in CloudTrail|Binary
|Is_CloudTrail_MultiRegion|Cloud Trail Multi-Region (yes/no)|True if CloudTrail is enabled in multiple regions|Binary
|Is_Cloud_Device|Cloud Asset (yes/no)|True if the asset is in cloud|Binary
|Is_Image_Old|Old Image (yes/no)|True if the instance image is older than 30 days|Binary
|Is_Image_Public|Public Image (yes/no)|True if the instance image is public|Binary
|Log_Group|Cloud Watch Log Group|Cloudwatch log group|String
|Old_Image_Age|Old Image Age|Old image age in months with log2 scaling|Float
|Parent_Image_ID|Parent Image ID|Parent image ID for the instance|String
|Target_Group|Target Group|Load balancer target groups|List
|Task_Definition|Task Definition|Container service task definition name|String
# Asset
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Asset_Category|Asset Category|Asset category (e.g., cloud or on-prem)|String
|Asset_Class|Asset Function|Asset function class (e.g., network or endpoint)|String
|Asset_Confidence_Score|Duplicated Asset Detection|Confidence score for potentially duplicated assets|Float
|Asset_GroupID|Asset Group ID|Asset group ID|String
|Asset_GroupName|Asset LDAP Groups|Asset LDAP CN groups|List
|Asset_Groups|Asset Groups|Groups associated with the asset|List
|Asset_Member|Asset LDAP Group Members|Asset LDAP full group members|List
|Asset_Name|Lucid Asset Name|Lucidum derived asset entity name|undefined
|Asset_OS|User's Assets|The asset(s) linked to the user|List
|Asset_OS.Asset_Name|Asset_OS.Asset_Name|Asset_OS.Asset_Name|String
|Asset_Type|Asset Type|Asset type (e.g., server or workstation)|String
|Auto_Scaling_Group|Auto Scaling Group|Asset auto-scaling group name (e.g., AWS EC2 auto-scaling group)|String
|Cloud_Instance_ID|Instance ID|Instance ID|String
|Cluster_Config|Cluster Config|Cluster configuration (e.g., VMWare)|List
|Cluster_ID|Cluster ID|Asset cluster ID|List
|Cluster_Name|Cluster Name|Asset cluster name|String
|Count_Asset|# of Assets|Number of assets linked to the user|Integer
|Data_Center_ID|Data Center ID|Data center ID|List
|EXT_IP_Address|Public IP Address|Public IP address(es)|List
|Encrypt_Mode|Encryption Mode|Asset encryption mode|String
|FQDN|Full Domain Name|Fully qualified domain name|String
|Host_ID|Host ID|Host ID|List
|Host_Name|Source Asset Name|Data source asset name|undefined
|IP_Address|IP Address|IP address(es)|List
|InstanceType|Instance Type|Instance type|String
|Instance_Name|Instance Name|Instance name|String
|Is_Accessible|Accessible (yes/no)|True if the asset is accessible|Binary
|Is_Critical_Asset|Critical Asset (yes/no)|True if the asset is critical according to data source|Binary
|Is_Encrypted|Encrypted (yes/no)|True if the asset is encrypted|Binary
|Is_Live_Migration|Live Migration Enabled (yes/no)|True if the live migration is enabled (e.g., VMWare VMotion)|Binary
|Is_Managed_Asset|IT Managed (yes/no)|True if the asset is managed by IT|Binary
|Is_Multi_Host_Access|Multi-Host Access (yes/no)|True if the asset has multiple-host access|Binary
|Is_OS_Old|Out-of-date OS (yes/no)|True if the operating system is out-of-date|Binary
|Is_Server|Server (yes/no)|True if the asset is a server according to data source|Binary
|Is_Snapshot|Snapshot (yes/no)|True if the asset is snapshot|Binary
|Is_Virtual|Virtual Machine (yes/no)|True if the asset is a virtual machine|Binary
|MAC_Address|MAC Address|MAC address(es)|List
|Not_Managed|IT Managed (yes/no)|True if the asset is NOT managed by IT|Binary
|OS|OS and Version|OS and version|String
|Resource_Pool|Resource Pool|Asset resource pool|String
|VCenter_ID|vCenter ID|vCenter ID|List
|VM_ID|VM ID|Virtual machine ID|List
|Vendor|Vendor|Asset vendor|String
# Hardware
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|CPU_Cores|CPU Cores|Number of CPU cores|Integer
|CPU_Usage|CPU Average Usage (%)|CPU average usage (%)|Float
|Carrier|Carrier|Mobile carrier|String
|Hardware_Config|Hardware Config|Hardware configuration (e.g., VMWare)|List
|IMEI|IMEI #|Mobile MEID/IMEI/ESN number|String
|MAC Vendor|MAC Vendor|MAC hardware vendors|List
|Memory_Size|Memory Size (GB)|Memory size (in GB)|Float
|Memory_Usage|Memory Usage (%)|Latest memory usage (%)|Float
|Mobile_Number|Mobile #|Mobile/phone number|String
|Model|Model|Hardware model|String
|Power_State|Power State|Asset power state|String
|SIM|SIM #|Mobile SIM card number|String
|Serial_Number|Serial Number|Hardware serial number|String
|Service_Tag|Service Tag|Asset IT service tag|String
|Storage_Size|Storage Size (GB)|Storage size (in GB)|Float
|Storage_Usage|Storage Usage (%)|Latest storage usage (%)|Float
|Vendor_Class|Vendor Class|Asset DHCP vendor class|String
|Volume_ID|Volume ID|Volume ID attached to the instance|String
# Data
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Bucket_File|Cloud Files|Bucket files|List
|Bucket_User|Bucket Users|Bucket user access history|List
|Data_Classification|Data Classification|Lucidum extrapolated data classification|String
|Data_Risk|Data Risk|Lucidum extrapolated data risk (higher value, riskier)|Integer
|Data_Store_ID|Data Store ID|Data store ID|List
|Data_Topic|Data Description|Lucidum extrapolated data topic keywords|String
|Data_Type|Data Category|Lucidum extrapolated data category|String
|File_Bucket|Cloud Bucket|File bucket names|List
|File_Name|File List|File access history|List
|Folder_Name|File Folder|File folder names|List
|Text_Cluster||Data topic cluster from Lucidum ML|Float
|User_Bucket|Bucket User Access|File bucket’s user access history|List
# Threat
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Count_Critical_Severity_Threat|Critical Threats|Number of critical-severity threats|Integer
|Count_High_Severity_Threat|High Threats|Number of high-severity threats|Integer
|EP_Infections|Malware/Threat Alerts|Number of malware infections or threats detected|Integer
|EP_Installed|Endpoint Agent (yes/no)|True if the endpoint protection agent is installed|Binary
|EP_Not_Installed|Endpoint Agent (yes/no)|True if the endpoint protection agent is NOT installed|Binary
|EP_Not_Updated|Agent Updated (yes/no)|True if the endpoint protection agent is NOT updated|Binary
|EP_Updated|Agent Updated (yes/no)|True if the endpoint protection agent is updated|Binary
|HostIDS_Log|Host IDS (yes/no)|True if the asset is monitored in host IDS|Binary
|HostIDS_Not_Log|Host IDS (yes/no)|True if the asset is NOT monitored in host IDS|Binary
|Is_SANS_Malicious|SANS Malicious IP (yes/no)|True if the asset's IP address is found in SANS attack list|Binary
|Is_TOR_Node|TOR Node IP (yes/no)|True if the asset's IP address is found in TOR exit node list|Binary
|NetworkIDS_Log|Network IDS (yes/no)|True if the asset is monitored in network IDS|Binary
|NetworkIDS_Not_Log|Network IDS (yes/no)|True if the asset is NOT monitored in network IDS|Binary
|Threat_List|Threat List|Threat list|List
# Age
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Agent_Status|Agent Status|Agent status on the asset (e.g., VM tool)|String
|End_Datetime|IP Assignment End Time|IP address assignment end epoch time|Datetime
|First_Discovered_Datetime|First Time Seen|The earliest epoch time discovered in any of the data sources|Datetime
|First_Lucidum_Datetime|First Ingestion Time|The earliest epoch time ingested into Lucidum|Datetime
|Is_New_Asset_Name|New Asset (yes/no)|True if the asset is newly found|Binary
|Is_New_Owner_Name|New User (yes/no)|True if the user is newly found|Binary
|Last_Boot_Datetime|Last Start Time|Asset last boot epoch time|Datetime
|Last_Discovered_Datetime|Last Time Seen|The latest epoch time discovered in any of the data sources|Datetime
|Last_Lockout_Datetime|Last Lockout Time|User last locked out epoch time (from LDAP)|Datetime
|Last_Password_Datetime|Last Password Set Time|User last password set epoch time (from LDAP)|Datetime
|Life_Desc|Life|Life (in human-readable format)|String
|Life_Hours|Life (Hours)|Life (in hours)|Float
|Start_Datetime|IP Assignment Start Time|IP address assignment start epoch time|Datetime
|Status|Status|Status|String
|run_time|Record Generated Time|The epoch time of Lucidum data ingestion|Datetime
# Vulnerability
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|CVE|CVE List|CVE IDs|List
|Count_CVE|CVE Count|Number of CVE vulnerabilities|Integer
|Count_Critical_Severity_Vuln|Critical Vulns|Number of critical-severity vulnerabilities|Integer
|Count_High_Severity_Vuln|High Vulns|Number of high-severity vulnerabilities|Integer
|Count_Mitigated_Vuln|Mitigated Vulns|Number of mitigated vulnerabilities|Integer
|Critical_CVE|Critical CVE List|Critical CVE IDs|List
|High_CVE|High CVE List|High CVE IDs|List
|VA_Not_Scan|Vuln Scan (yes/no)|True if the asset is NOT scanned by vulnerability assessment|Binary
|VA_Scan|Vuln Scan (yes/no)|True if the asset is scanned by vulnerability assessment|Binary
|Vuln_List|Vulnerabilities|Vulnerability details|List
|Vuln_Name|Vulnerability Names|Vulnerability names|List
# User
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Count_SSO_Failed|User SSO Failures|Number of failed SSO logins|Integer
|Count_User|# of Users|Number of users linked to the asset|Integer
|Is_Active|User Activated (yes/no)|True if the user is activated|Binary
|Is_Admin|System Admin (yes/no)|True if the user has admin permission|Binary
|Is_Admin|User Admin (yes/no)|True if the user is an admin|Binary
|Is_Disabled|User Disabled (yes/no)|True if the user account is disabled|Binary
|Is_Linked_Device|Related to Asset (yes/no)|True if the user has one or more assets linked|Binary
|Is_Lockout|User Locked Out (yes/no)|True if the user is locked out (from LDAP)|Binary
|Is_Terminated|User Terminated (yes/no)|True if the user is terminated in HR|Binary
|List_Users|All Login Users|List of users on the asset|List
|List_Users.Owner_Name|List_Users.Owner_Name|Login username|String
|Owner_Department|Department|The business department associated with the user account|String
|Owner_Email|Email|The email associated with the user account|String
|Owner_GroupName|User LDAP Groups|User LDAP CN groups|List
|Owner_Groups|User Groups|Groups associated with the user|List
|Owner_ID|User IDs|The user IDs linked to the user account|List
|Owner_Job_Title|Job Title|The job title associated with the user account|String
|Owner_Key|User Key|The API access key(s) associated with the user (AWS) account|List
|Owner_Manager|Manager|The manager’s name associated with the user account|String
|Owner_Member|User LDAP Group Members|User LDAP full group memberships|List
|Owner_Name|Lucid User Name|Lucidum derived user entity name|String
|Owner_Sources|User Sources|User linked data source(s)|List
|Owner_Status|User Status|User status|List
|Owner_Type|User Type|User type|String
|Role_Assume_Principal|Role Assuming Principals|Cloud role assuming principal(s)|List
|Role_ID|Role ID|Role ID|String
|Role_Name|Role Name|Role name|List
|Source_User_Name|Source User Name|Data source user account name|undefined
|User_Confidence_Score|Duplicated User Detection|Confidence score for potentially duplicated users|Float
|displayName|Person Full Name|The person's full/display name|String
# Location
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Building|Building|Building name|String
|Environment|Environment|Environment|String
|Location|Location|Location|String
|Location_Country_ISO_Code|Country Code|Location country ISO code|String
|Location_Country_Name|Country Name|Location country name|String
|Location_Lat|Lat / Long|Location latitude|Float
|Location_Long|Lat / Long|Location longitude|Float
|Rack|Rack|Rack name|String
|Region|Region|Region|String
|Site|Site|Site|String
# Risk
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|RiskChange1||Risk top impact 1|Float
|RiskChange2||Risk top impact 2|Float
|RiskChange3||Risk top impact 3|Float
|RiskFactor1|Top Variable 1|Risk top variable 1|String
|RiskFactor2|Top Variable 2|Risk top variable 2|String
|RiskFactor3|Top Variable 3|Risk top variable 3|String
|RiskReason1|Top Factor 1|Risk top factor 1|String
|RiskReason2|Top Factor 2|Risk top factor 2|String
|RiskReason3|Top Factor 3|Risk top factor 3|String
|Risk_CDF|Risk CDF|Statistical risk score (1-100)|Float
|Risk_Level|Risk Level|Risk level|String
|Risk_Reasons|Risk Factors|All risk factors|List
|Risk_STD|Risk Ranking|Standardized/ranked risk score (1-100)|Float
|Risk_Score|Risk Score|Raw risk score (higher value, riskier)|Float
# Data Source
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Details|Data Source Details|Details from each data source|List
|Details.Status|Status|Status|String
|Details.profile|Data Source Profile|Data ingestion profile configuration|String
|Missing_Sources|Non-present Sources|Data source(s) NOT present|List
|sourcetype|Data Sources|Data source(s)|List
# Applications
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|App_Desc|SaaS Application Description|SaaS application description|String
|App_Name|SaaS Application|SaaS application name (e.g., Okta)|String
|App_Type|SaaS Application Type|SaaS application type (e.g., SSO)|String
|App_Version|SaaS Application Version|SaaS application version|String
|Application|Applications|Application list|List
|Count_Critical_Risk_App|Critical Risk Apps|Number of critical risk applications|Integer
|Count_High_Risk_App|High Risk Apps|Number of high risk applications|Integer
|Critical_Risk_App|Critical Risk Apps List|Critical risk applications|List
|Event_List|SaaS Application Events|SaaS application events history|List
|High_Risk_App|High Risk Apps List|High risk applications|List
|User_Agent|User Agent|User agent detected|String
|app|Applications|Application|String
|diff_app|Applications with Different Versions|Applications with different versions|String
|percent_diff_app||% of apps with different versions|Float
# Network
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Cert_Algorithm|Certificate Algorithm|SSL certificate encryption algorithm|String
|Cert_ID|Certificate ID|SSL certificate ID|String
|Cert_Rating|Certificate Rating|SSL certificate rating|String
|Cert_Version|Certificate Version|SSL certificate protocol version|String
|DNS_CNAME|DNS CNAME|DNS canonical name record|String
|DNS_Domain|Domain|Asset domain name|String
|DNS_MX|DNS MX|DNS mail exchange record|String
|DNS_NS|DNS NS|DNS nameserver record|String
|DNS_Name|DNS Name|DNS name|String
|DNS_PTR|DNS PTR|DNS pointer record|String
|DNS_Security|DNS Security|DNS security status|String
|DNS_Type|DNS Type|DNS type|String
|DNS_Zone|DNS Zone|DNS zone|String
|EXT_Open_Ports|External Ports|Open ports accessible externally|List
|EXT_Services|External Services|Services accessible externally|List
|Firewall_Action|Firewall Action|Firewall default action|String
|Firewall_Rules|Firewall Rules|Firewall rules|List
|IP_Pool|IP Pool|IP address pool|String
|Instance_Key|Instance Key|Instance key name|String
|Internet_Gateway_ID|Internet Gateway ID|Internet gateway ID|String
|Is_Public|Public Facing (yes/no)|True if the asset may be public-facing (e.g., has public IP address)|Binary
|Is_Public_Inbound|Open Inbound Access (yes/no)|True if the asset is open to public inbound connection|Binary
|Management_VIP|Management VIP|Management virtual IP (VIP) address|String
|NAS_ID|NAS ID|NAS ID|String
|NAS_Port|NAS Port|NAS port|String
|NAT_Gateway_ID|NAT Gateway ID|NAT gateway ID|String
|Network_ACL_ID|Network ACL ID|Network access control (ACL) ID|String
|Network_Config|Network Config|Network configuration (e.g., VMWare)|List
|Network_ID|Network ID|Network ID|List
|Network_Interface_ID|Network Interface ID|Network interface ID|String
|Network_Segment|Network Segment|Network segment|String
|Open_Port_List|Ports|Open ports|List
|Port_Group|Port Group|Asset network port group|List
|Public_ISP|ISP|Public internet service provider according to source or extrapolated by Lucidum|String
|Route_Table_ID|Route Table ID|Route table ID|String
|Security_Group_ID|Security Group ID|Cloud security Group IDs|List
|Security_Group_IP|Security Group IP Range|Cloud security group IP ranges permitted|List
|Security_Group_Name|Security Group Name|Cloud security group names|List
|Security_Group_Rules|Security Group Rules|Security group rules|List
|Services|Services|Services running on the asset|List
|Subnet_ID|Subnet ID|Cloud subnet ID|String
|Switch_Name|Switch Name|Network switch name|String
|VLAN_ID|VLAN ID|VLAN ID|String
|VLAN_Name|VLAN Name|VLAN name|String
|VPN_Gateway_ID|VPN Gateway ID|VPN gateway ID|String
|VPN_Profile|VPN Profile|VPN profile name|String
|Vpc_ID|VPC ID|Cloud VPC ID|String
# Others
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Asset_Desc|Asset Description|Asset description|String
|Cost_Center|Cost Center|Cost center name/ID|String
|Count_Login|Login Count|Number of user logins|Integer
|Is_EC2_Idle|Idle Instance (yes/no)|True if the asset may be idling|Binary
|Monthly_Cost|Monthly Cost (US Dollar)|Monthly running costs (in US dollar)|Float
|Organization|Organization|Organization name|String
|Purpose|Purpose|Asset’s purpose according to data source|String
|Tickets|User Tickets|User’s service tickets|List
|User_Ratio||Server login user ratio|Float
|_time||Data processing end epoch time|Datetime
|_utc||Database UTC timestamp (for data retention)|Datetime
|merger_time||Data processing start epoch time|Datetime
|notes|Comments|Comments added|List
|pagerank||Network flow pagerank|Float
# 
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|entity|Asset Entity|Asset entity (Hostname + Username + IP)|String
# Compliance
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Alarm_Name|Cloud Watch Alarm|Cloudwatch alarm name|String
|Compliance_Entity|Compliance Entity|Compliance entity|String
|Count_Missing_Patch|Missing Patches|Number of missing system patches|Integer
|Count_Non_Compliance|# of Non-Compliance|Number of non-compliances|Integer
|Filter_Name|Cloud Watch Filter|Cloudwatch filter name|String
|Filter_Pattern|Cloud Watch Filter Pattern|Cloudwatch filter pattern|String
|Finding|Security Findings|Asset security/compliance findings|List
|Is_CloudTrail_Validation|Cloud Trail Validation (yes/no)|True if CloudTrail log file validation is enabled|Binary
|Is_Logging|Logging Enabled (yes/no)|True if the asset logging is enabled|Binary
|Is_MFA_Configured|MFA Configured|MFA configuration status of the user|List
|Is_Replicating|Replication Enabled (yes/no)|True if the asset replication is enabled (e.g., s3 bucket replication)|Binary
|Is_Root_Access|Root Access (yes/no)|True if the cloud account has root access enabled|Binary
|Is_Root_MFA|Root MFA Enabled (yes/no)|True if the cloud account has root MFA enabled|Binary
|Is_Versioning|Versioning Enabled (yes/no)|True if the asset versioning is enabled|Binary
|Metric_Name|Cloud Watch Metric|Cloudwatch metric name|String
|Metric_Space|Cloud Watch Metric Space|Cloudwatch metric space|String
|Missing_Patches|Missing Patch List|List of missing system patches|List
|Non_Compliance|Non-Compliance List|Non-compliance list|List
|Source|Compliance Source|Compliance source|String
# Tags
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Image_Tag|Image Tag|Cloud instance image tags|List
|Tag|Tag|Tags|List
# Policy
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Count_Admin_Policy|Admin Policies|Number of admin policies|Integer
|Is_Password_Changeable|User Password Changeable (yes/no)|True if user can change the password|Binary
|Is_Password_Enabled|User Password Enabled|User password enabled status|List
|Is_Password_Expire|User Password Expired (yes/no)|True if the user's password is expired|Binary
|Is_Password_Lower|User Password with Lower Letter (yes/no)|True if user's password must contain lower-case character|Binary
|Is_Password_Not_Required|User Password Not Required (yes/no)|True if the user's password is not required|Binary
|Is_Password_Number|User Password with Number (yes/no)|True if user's password must contain numbers|Binary
|Is_Password_Resetable|User Password Resettable (yes/no)|True if user's password is resettable|Binary
|Is_Password_Symbol|User Password with Symbol (yes/no)|True if user's password must contain symbols|Binary
|Is_Password_Upper|User Password with Upper Letter (yes/no)|True if user's password must contain upper-case character|Binary
|Owner_Policies|User Policies|Policies associated with the user|List
|Password_Age|User Password Valid Age|Number of days that a user password is valid|Integer
|Password_Length|User Password Min. Length|Minimum length required for user's password|Integer
|Password_Reuse|User Password Reuse Times|Maximum user password reuse times|Integer
|Policy_Name|Policy|Policy name|String
|Policy_Statement|Policy Statement|Policy statements|List
# DevOps
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Docker_Image_ID|Docker Image ID|Docker image digest hash ID|String
|Repo_Name|Docker Repo|Docker repository name|String
# LifeCycle
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Expired_Datetime|Asset Expiry Time|Asset lifecycle expiry epoch time|Datetime
|Purchase_Datetime|Purchase Time|Asset purchase epoch time|Datetime
|Purchase_Order|Purchase Order|Asset purchase order number|String
|Purchase_Price|Purchase Price|Asset purchase price|Float
|Purchase_Quantity|Purchase Quantity|Asset purchase quantity|Float
|Purchase_Source|Purchase Source|Asset purchase source|String
|Warranty_Datetime|Warranty Expiry Time|Asset warranty expiry epoch time|Datetime
# CAASM
|Field Name|Display Name|Description|Data Type|
|--------|--------|------|------|
|Maturity|Maturity Score|Organization cyber-security maturity scores|List
|Maturity Factor|Maturity Factors|Organization cyber-security maturity improvements|List