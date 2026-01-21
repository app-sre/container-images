terraform {
  required_providers {
    dynatrace = {
      version = "1.75.1"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "5.6.0"
    }
  }
}

