echo "***********************"
echo "Modifying 3-artifactory-optional"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGION
#INPUT: VGCPREPOID
#VARIABLE: REPOEXISTS - computed
#INPUT: REMOTEREPO"
#INPUT: REMOTEREPOUID"
#INPUT: REMOTEREPOPWD"

#Check if repo already exists - 0 is yes or 1 if no
gcloud artifacts repositories describe ${VGCPREPOID}-images --location=$VGCPREGIONPRIMARY --project=$VGCPPROJECT
IMAGEREPOEXISTS=$?
gcloud artifacts repositories describe ${VGCPREPOID}-charts --location=$VGCPREGIONPRIMARY --project=$VGCPPROJECT
CHARTSREPOEXISTS=$?

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/4-artifactory-optional/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/4-artifactory-optional/main.tf"
sed -i "s#INSERT_VGCPREPOID#$VGCPREPOID#g" "./platform/terraform/4-artifactory-optional/main.tf"

sed -i "s#INSERT_IMAGEREPOEXISTS#$IMAGEREPOEXISTS#g" "./platform/terraform/4-artifactory-optional/main.tf"
sed -i "s#INSERT_CHARTSREPOEXISTS#$CHARTSREPOEXISTS#g" "./platform/terraform/4-artifactory-optional/main.tf"

sed -i "s#INSERT_REMOTEREPO#$REMOTEREPO#g" "./platform/terraform/4-artifactory-optional/main.tf"
sed -i "s#INSERT_REMOTEHELM#$REMOTEHELM#g" "./platform/terraform/4-artifactory-optional/main.tf"
sed -i "s#INSERT_REMOTEUSER#$REMOTEUSER#g" "./platform/terraform/4-artifactory-optional/main.tf"
sed -i "s#INSERT_REMOTEPASS#$REMOTEPASS#g" "./platform/terraform/4-artifactory-optional/main.tf"
cat "./platform/terraform/4-artifactory-optional/main.tf"

dir=platform/terraform/4-artifactory-optional/

echo "***********************"
echo "Initializing Terraform to provision GCP Artifacts"
echo "***********************"
cd ${dir}   
env=${dir%*/}
env=${env#*/}  
echo ""
echo "*************** TERRAFOM PLAN ******************"
echo "******* At environment: ${env} ********"
echo "*************************************************"
terraform init || exit 1
cd ../../../../


echo "***********************"
echo "Executing Terraform to provision GCP Artifacts"
echo "***********************"
cd ${dir}   
env=${dir%*/}
env=${env#*/}  
echo ""
echo "*************** TERRAFOM PLAN ******************"
echo "******* At environment: ${env} ********"
echo "*************************************************"
terraform apply -auto-approve -parallelism=1 || exit 1
cd ../../../../