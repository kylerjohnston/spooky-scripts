#!/bin/bash

echo "Backing up to S3"
/usr/bin/aws --profile descartes-s3-uploader s3 cp /home/krj/Documents/financial/register/gnucash-register-sqlite.gnucash s3://spinoza-web/gnucash-registers/

exit $?
