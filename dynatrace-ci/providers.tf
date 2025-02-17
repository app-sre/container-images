terraform {
  required_providers {
    dynatrace = {
      version = "1.74.0"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "4.6.0"
    }
  }
}

