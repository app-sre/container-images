terraform {
  required_providers {
    dynatrace = {
      version = "1.88.0"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "4.8.0"
    }
  }
}

