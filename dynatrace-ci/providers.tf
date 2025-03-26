terraform {
  required_providers {
    dynatrace = {
      version = "1.76.0"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "4.7.0"
    }
  }
}

