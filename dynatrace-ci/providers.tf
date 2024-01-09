terraform {
  required_providers {
    dynatrace = {
      version = "1.34.0"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "3.23.0"
    }
  }
}

