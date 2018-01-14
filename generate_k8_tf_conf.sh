#!/bin/bash

#use kops to generate k8 tf config
kops create cluster --name m8tt.ddigital.org --dns-zone ddigital.org --state=s3://digital-tf-state  --out=. --target terraform  --zones eu-central-1a,eu-central-1b
