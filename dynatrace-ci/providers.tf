terraform {
  required_providers {
    dynatrace = {
      version = "1.79.3"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "4.8.0"
    }
  }
}

