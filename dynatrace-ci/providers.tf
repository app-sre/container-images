terraform {
  required_providers {
    dynatrace = {
      version = "1.87.3"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "4.8.0"
    }
  }
}

