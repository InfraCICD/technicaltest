#AWS
provider "aws" {
    region = "eu-west-2"
    shared_credentials_file = "/Users/.tf/.aws/creds"
    profile = "customprofile"
    }