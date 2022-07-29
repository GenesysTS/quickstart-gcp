echo "***********************"
echo "Modifying Terraform Files for user variables and inputs"
echo "***********************"
#ALL UNIQUE INPUTS
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGCPREGIONSECONDARY
#INPUT: VDOMAIN
#INPUT: VGKECLUSTER
#INPUT: VEMAILADDRESS
#INPUT: VSTORAGEBUCKET



echo "***********************"
echo "Modifying 6-thirdparty"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGKECLUSTER
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/cloudbuild/6-thirdparty/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/cloudbuild/6-thirdparty/main.tf"
sed -i "s#INSERT_VGKECLUSTER#$VGKECLUSTER#g" "./platform/terraform/cloudbuild/6-thirdparty/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/cloudbuild/6-thirdparty/main.tf"
cat "./platform/terraform/cloudbuild/6-thirdparty/main.tf"

echo "***********************"
echo "Initializing Terraform to provision GCP Platform"
echo "***********************"
for dir in platform/terraform/cloudbuild/6-thirdparty/*
do 
    cd ${dir}   
    env=${dir%*/}
    env=${env#*/}  
    echo ""
    echo "*************** TERRAFOM PLAN ******************"
    echo "******* At environment: ${env} ********"
    echo "*************************************************"
    terraform init || exit 1
    cd ../../../../
done

echo "***********************"
echo "Executing Terraform to provision GCP Platform"
echo "***********************"
for dir in platform/terraform/cloudbuild/*
do 
    cd ${dir}   
    env=${dir%*/}
    env=${env#*/}  
    echo ""
    echo "*************** TERRAFOM PLAN ******************"
    echo "******* At environment: ${env} ********"
    echo "*************************************************"
    terraform apply -auto-approve || exit 1
    cd ../../../../
done
