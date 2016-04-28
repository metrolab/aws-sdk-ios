#!/bin/sh


# remove everything generated by this script
function cleanup
{
    rm -rf docs
    rm -rf Documentation
}


VERSION="2.4.1"
if [ -n $1 ] && [ "$1" == "clean" ];
then
	cleanup
	exit 0
else
	cd "$SOURCE_ROOT"

    if [ -d docs ];
    then
        cleanup
    fi

    rm -rf docs_tmp
    mkdir -p docs
    mkdir -p docs_tmp

    cp -r AWSAPIGateway ./docs_tmp/AWSAPIGateway
    cp -r AWSAutoScaling ./docs_tmp/AWSAutoScaling
    cp -r AWSCore ./docs_tmp/AWSCore
    cp -r AWSCognito ./docs_tmp/AWSCognito
    cp -r AWSCognitoIdentityProvider ./docs_tmp/AWSCognitoIdentityProvider
    cp -r AWSCloudWatch ./docs_tmp/AWSCloudWatch
    cp -r AWSDynamoDB ./docs_tmp/AWSDynamoDB
    cp -r AWSEC2 ./docs_tmp/AWSEC2
    cp -r AWSElasticLoadBalancing ./docs_tmp/AWSElasticLoadBalancing
    cp -r AWSIoT ./docs_tmp/AWSIoT
    cp -r AWSKinesis ./docs_tmp/AWSKinesis
    cp -r AWSLambda ./docs_tmp/AWSLambda
    cp -r AWSMachineLearning ./docs_tmp/AWSMachineLearning
    cp -r AWSMobileAnalytics ./docs_tmp/AWSMobileAnalytics
    cp -r AWSS3 ./docs_tmp/AWSS3
    cp -r AWSSES ./docs_tmp/AWSSES
    cp -r AWSSimpleDB ./docs_tmp/AWSSimpleDB
    cp -r AWSSNS ./docs_tmp/AWSSNS
    cp -r AWSSQS ./docs_tmp/AWSSQS

    rm -rf ./docs_tmp/AWSCore/Bolts
    rm -rf ./docs_tmp/AWSCore/Fabric
    rm -rf ./docs_tmp/AWSCore/FMDB
    rm -rf ./docs_tmp/AWSCore/GZIP
    rm -rf ./docs_tmp/AWSCore/Mantle
    rm -rf ./docs_tmp/AWSCore/Reachability
    rm -rf ./docs_tmp/AWSCore/TMCache
    rm -rf ./docs_tmp/AWSCore/UICKeyChainStore
    rm -rf ./docs_tmp/AWSCore/XMLDictionary
    rm -rf ./docs_tmp/AWSCore/XMLWriter
    rm -rf ./docs_tmp/AWSCognito/Internal
    rm -rf ./docs_tmp/AWSCognito/Fabric
    rm -rf ./docs_tmp/AWSCognitoIdentityProvider/Internal
    rm -rf ./docs_tmp/AWSMobileAnalytics/Internal
    rm -rf ./docs_tmp/AWSIoT/Internal

    cd docs_tmp

    # generate documenation
    appledoc --verbose 0 \
                            --output ../docs \
                            --exit-threshold 2 \
                            --no-repeat-first-par \
                            --explicit-crossref \
                            --docset-install-path ../docs \
                            --docset-bundle-filename com.amazon.aws.ios.docset \
                            --company-id aws.amazon.com \
                            --project-name "AWS Mobile SDK for iOS v${VERSION}" \
                            --project-version "${VERSION}" \
                            --project-company "Amazon Web Services, Inc." \
                            --create-html \
                            --finalize-docset \
                            --keep-intermediate-files \
                            --index-desc ../aws-sdk-for-ios.markdown \
                            ./

    # get command execution result
    result=$?

    if [ $result != 0 ];
    then
        echo "Building the AWS Mobile SDK for iOS documentation FAILED!"
        cleanup;
        exit 1;
    fi

    cd "$SOURCE_ROOT"

	# pack html doc into a zip file
    (cd docs/html; zip -q -r --symlinks ../aws-sdk-ios-docs.zip .)

    rm -rf Documentation
    mkdir "$BUILT_PRODUCTS_DIR"/Documentation
    mv docs/html "$BUILT_PRODUCTS_DIR"/Documentation
    mv docs/com.amazon.aws.ios.docset "$BUILT_PRODUCTS_DIR"/Documentation
    mv docs/aws-sdk-ios-docs.zip "$BUILT_PRODUCTS_DIR"/Documentation
    rm -rf docs
    rm -rf docs_tmp

	exit 0
fi