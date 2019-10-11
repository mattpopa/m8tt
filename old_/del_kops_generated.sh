#!/bin/bash

#Use kops to destroy the cluster 
kops delete cluster --yes --name m8tt.ddigital.org --state=s3://digital-tf-state

